#!/usr/bin/env bash
# stage-web-demo.sh — stage a published OpenLieroX WASM build into the web demo.
#
# Usage: tools/stage-web-demo.sh <channel> <tag>
#   channel : "release" | "prerelease"
#   tag     : the openlierox/openlierox release tag, e.g. 20260712.2
#
# Downloads the tag's *-wasm.zip from openlierox/openlierox, stages the engine
# files into web-demo/<channel>/<tag>/, prunes any older versions of that
# channel, and records the version in web-demo/channels.json (read at runtime by
# the web-demo pages) and .web-demo-version-<channel> (the skip-if-unchanged
# marker).
#
# GitHub releases/prereleases are the single source of truth: the caller decides
# which tag maps to which channel (the stable "Latest" release -> release; the
# newest prerelease -> prerelease) and passes it in.
#
# Requires: gh (authenticated; GH_TOKEN in CI), jq, unzip.
# No-op (exit 0, no changes) when the channel is already at <tag>.

set -euo pipefail

CHANNEL="${1:?usage: stage-web-demo.sh <channel> <tag>}"
TAG="${2:?usage: stage-web-demo.sh <channel> <tag>}"
REPO="openlierox/openlierox"

case "$CHANNEL" in
  release | prerelease) ;;
  *) echo "unknown channel: $CHANNEL (expected release|prerelease)" >&2; exit 2 ;;
esac

# Repo root = parent of the dir holding this script (tools/).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

VERSION_FILE=".web-demo-version-$CHANNEL"
if [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE")" = "$TAG" ]; then
  echo "[$CHANNEL] already at $TAG, nothing to do"
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "[$CHANNEL] downloading WASM bundle for $TAG..."
gh release download "$TAG" --repo "$REPO" --pattern "*-wasm.zip" --dir "$TMP"
unzip -q "$TMP"/*-wasm.zip -d "$TMP/extracted"

# package-wasm.yml names the bundle's top-level directory after the version
# (openlierox-<version>-wasm), so don't hardcode it -- pick the one directory
# the zip extracted to.
SRC="$(find "$TMP/extracted" -mindepth 1 -maxdepth 1 -type d | head -1)"
if [ -z "$SRC" ]; then
  echo "no directory found inside the WASM bundle" >&2
  exit 1
fi

DEST="web-demo/$CHANNEL/$TAG"
rm -rf "$DEST"
mkdir -p "$DEST"

# Engine files (required).
for f in openlierox.js openlierox.wasm openlierox.data; do
  cp "$SRC/$f" "$DEST/"
done
# Optional metadata / host-config files.
for f in build-info.json _headers .htaccess; do
  [ -f "$SRC/$f" ] && cp "$SRC/$f" "$DEST/"
done

# Prune older versions of this channel; keep only the one just staged.
for dir in "web-demo/$CHANNEL"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  [ "$name" = "$TAG" ] || rm -rf "web-demo/$CHANNEL/$name"
done

# Provenance for the dropdown label / debugging, from the bundle's build-info.json.
COMMIT="unknown"; DATE="unknown"
if [ -f "$DEST/build-info.json" ]; then
  COMMIT="$(jq -r '.commitShort // .commit // "unknown"' "$DEST/build-info.json")"
  DATE="$(jq -r '.commitDate // "unknown"' "$DEST/build-info.json")"
fi

# Record the version in the runtime manifest (create it if missing). The pages
# fetch channels.json and build the engine path as /web-demo/<channel>/<version>/.
CHANNELS="web-demo/channels.json"
[ -f "$CHANNELS" ] || echo '{}' > "$CHANNELS"
tmpjson="$(mktemp)"
jq --arg ch "$CHANNEL" --arg v "$TAG" --arg c "$COMMIT" --arg d "$DATE" \
  '.[$ch] = {version: $v, commit: $c, date: $d}' "$CHANNELS" > "$tmpjson"
mv "$tmpjson" "$CHANNELS"

echo "$TAG" > "$VERSION_FILE"
echo "[$CHANNEL] staged $TAG -> $DEST"
