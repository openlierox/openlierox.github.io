---
layout: default
title: Web Demo
permalink: /web-demo/
manifest: /web-demo/manifest.webmanifest
---
<!--
  The WebAssembly build of OpenLieroX is multi-threaded (pthreads /
  SharedArrayBuffer), which requires the page to be "cross-origin isolated"
  (COOP: same-origin + COEP). GitHub Pages can't send those headers, so we
  load coi-serviceworker.js, which installs a service worker that adds them.
  Its /web-demo/ scope isolates THIS page and also covers the engine
  assets under /web-demo/<channel>/<version>/, so SharedArrayBuffer is available.

  The page UI below is adapted from the engine's standalone index.html: the
  centred status overlay, the loadingDone/showStarting state machine, the
  olxOnEngineReady hook and the canvas aspect-ratio correction (for accurate
  mouse coords when the canvas is letter-boxed in fullscreen). The standalone's
  PWA bits — install button, manifest/apple-mobile meta tags and display-mode
  "standalone" handling — are intentionally omitted: they only make sense for
  the full-page app, not this in-page demo.

  The heavy binaries (openlierox.js / .wasm / .data, ~25 MB per channel) are
  bundled in this repo under /web-demo/<channel>/<version>/ and loaded from the
  same origin. The bootstrap at the end reads /web-demo/channels.json, resolves
  the chosen channel's folder into ENGINE_DIR (used by Module.locateFile), and
  injects the engine <script>. A dropdown lets the visitor switch channel
  (release / pre-release) via ?channel=… and a reload.
-->
<script src="{{ '/web-demo/coi-serviceworker.js' | relative_url }}"></script>

## Play OpenLieroX in your web browser

The web version of OpenLieroX is just a demo. It has no network multiplayer and
has worse performance than running the game locally.

For the full experience [Download the game]({{ '/downloads/' | relative_url }}).

You can also [open the demo as a full-screen web app]({{ '/web-demo/shell.html' | relative_url }})
and install it to your device's home screen for a chrome-free, native-like experience.

{::nomarkdown}
<style>
#olx-game{display:flex;flex-direction:column;align-items:center;background:#111;color:#ddd;font-family:system-ui,sans-serif;border:1px solid #444;margin:0 auto;max-width:960px}
#olx-game #fs-area{position:relative;width:640px;height:480px}
#olx-game #status{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);z-index:10000;pointer-events:none;text-align:center;max-width:90%;padding:10px 16px;border-radius:6px;background:rgba(0,0,0,.75);color:#ddd;font:14px/1.4 monospace}
#olx-game #status.err{background:#803030;color:#fff}
#olx-game #toolbar{padding:4px 0}
#olx-game #toolbar button,#olx-game #toolbar select{background:#2a2a2a;color:#ddd;border:1px solid #444;padding:4px 10px;font:12px system-ui,sans-serif;cursor:pointer;border-radius:3px}
#olx-game #toolbar button:hover,#olx-game #toolbar select:hover{background:#3a3a3a}
#olx-game #canvas{width:640px;height:480px;display:block;background:#000;outline:0;image-rendering:pixelated}
#olx-game #fs-area:fullscreen{width:100vw;height:100vh;background:#000}
#olx-game #fs-area:fullscreen #canvas{width:100%;height:100%}
#olx-game #log{max-height:25vh;overflow:auto;padding:4px 10px;background:#181818;font:12px/1.3 monospace;white-space:pre-wrap;align-self:stretch}
#olx-game #log.err{color:#f99}
</style>

<div id="olx-game">
  <!-- #fs-area is the element that goes fullscreen — it holds both the canvas
       and the status overlay so the overlay stays visible (in the fullscreen
       top layer) while the game is still loading. -->
  <div id="fs-area">
    <canvas id="canvas" width="640" height="480" tabindex="-1" oncontextmenu="event.preventDefault()"></canvas>
    <div id="status">Loading OpenLieroX…</div>
  </div>
  <div id="toolbar"><select id="channel" title="Choose which build to play" aria-label="Choose which build to play"></select> <button id="fs-toggle" type="button">Enter fullscreen</button> <button id="install-btn" type="button">Install web app</button></div>
  <pre id="log"></pre>
</div>

<script>
const WEBDEMO_BASE="{{ '/web-demo/' | relative_url }}";let ENGINE_DIR="";const statusEl=document.getElementById("status"),logEl=document.getElementById("log");function appendLog(e,t){logEl.textContent+=e+"\n",logEl.scrollTop=logEl.scrollHeight,t&&logEl.classList.add("err")}let loadingDone=!1;function showStarting(){loadingDone||(loadingDone=!0,statusEl.style.display="",statusEl.classList.remove("err"),statusEl.textContent="Starting OpenLieroX…")}function exitFullscreenIfActive(){document.fullscreenElement&&document.exitFullscreen().catch((()=>{}))}window.olxOnEngineExit=e=>exitFullscreenIfActive(),window.olxOnEngineReady=()=>{statusEl.style.display="none"};var Module={locateFile:(p)=>ENGINE_DIR+p,canvas:(()=>{const e=document.getElementById("canvas");return e.addEventListener("webglcontextlost",(e=>{alert("WebGL context lost — please reload."),e.preventDefault()}),!1),e})(),print:e=>{Module.printAccept&&!Module.printAccept(e)||(console.log(e),appendLog(e,!1))},printErr:e=>{Module.printAccept&&!Module.printAccept(e)||(console.warn(e),appendLog(e,!0))},setStatus:e=>{if(/error|abort|exception/i.test(e=e||""))return statusEl.style.display="",statusEl.textContent=e,void statusEl.classList.add("err");if(loadingDone)return;const t=/^Downloading data\.\.\. \((\d+)\/(\d+)\)$/.exec(e);t&&t[1]===t[2]?showStarting():(statusEl.style.display=e?"":"none",statusEl.textContent=e,statusEl.classList.remove("err"))},monitorRunDependencies:e=>{0===e&&showStarting()},printAccept:e=>!/^(dependency:|still waiting on run dependencies|\(end of list\))/.test(e),onAbort:e=>{exitFullscreenIfActive(),Module.setStatus("Aborted: "+e)},onExit:()=>exitFullscreenIfActive()};Module.setStatus("Downloading…"),window.onerror=e=>Module.setStatus("Exception: "+e),window.addEventListener("keydown",(e=>{const t=e.target;if(!t||"INPUT"!==t.tagName&&"TEXTAREA"!==t.tagName&&!t.isContentEditable)if(!(e.altKey||e.ctrlKey||e.metaKey)||"ArrowLeft"!==e.code&&"ArrowRight"!==e.code&&"ArrowUp"!==e.code&&"ArrowDown"!==e.code)switch(e.code){case"ArrowLeft":case"ArrowRight":case"ArrowUp":case"ArrowDown":case"Space":case"Tab":case"Backspace":case"F1":e.preventDefault()}else e.preventDefault()}),!0),(()=>{const e=document.getElementById("fs-area"),t=document.getElementById("fs-toggle");document.fullscreenEnabled?(t.addEventListener("click",(()=>{document.fullscreenElement?document.exitFullscreen():e.requestFullscreen().catch((e=>appendLog("Fullscreen request failed: "+e,!0)))})),document.addEventListener("fullscreenchange",(()=>{t.textContent=document.fullscreenElement?"Exit fullscreen":"Enter fullscreen"}))):t.style.display="none"})()
</script>
<script>
// "Install web app" button. This page links the same manifest as shell.html
// (see the `manifest` front-matter / the <link rel="manifest"> the layout
// emits), and that manifest's start_url is /web-demo/shell.html — so a Chromium
// install triggered HERE installs the standalone shell, not this embed page.
// Browsers without beforeinstallprompt (iOS Safari, Firefox) can't install
// in-place, so we send the user to the shell, which carries its own install
// button and iOS "Add to Home Screen" instructions.
(() => {
  const installBtn = document.getElementById("install-btn");
  if (!installBtn) return;
  const shellUrl = "{{ '/web-demo/shell.html' | relative_url }}";

  // Already running as the installed app? Nothing to install.
  const isStandalone = window.navigator.standalone === true ||
    (window.matchMedia && window.matchMedia("(display-mode: standalone)").matches);
  if (isStandalone) { installBtn.style.display = "none"; return; }

  let deferredPrompt = null;
  window.addEventListener("beforeinstallprompt", (e) => { e.preventDefault(); deferredPrompt = e; });
  window.addEventListener("appinstalled", () => { installBtn.style.display = "none"; });

  installBtn.addEventListener("click", async () => {
    if (deferredPrompt) {                 // Chromium: real prompt -> installs the shell (manifest start_url)
      deferredPrompt.prompt();
      await deferredPrompt.userChoice;
      deferredPrompt = null;
      return;
    }
    window.location.href = shellUrl;      // iOS/Firefox/criteria-not-met: install from the standalone shell instead
  });
})();
</script>
<script>
// Pick which build to load. channels.json (written by the update workflow) maps
// each channel to its current version; the engine binaries live at
// /web-demo/<channel>/<version>/. The visitor's choice rides in ?channel=…, so
// switching just reloads the page (only one engine can be loaded at a time).
(async () => {
  const params = new URLSearchParams(location.search);
  let channel = params.get("channel");
  let channels;
  try {
    const res = await fetch(WEBDEMO_BASE + "channels.json", { cache: "no-store" });
    if (!res.ok) throw new Error("HTTP " + res.status);
    channels = await res.json();
  } catch (e) {
    Module.setStatus("Error loading the build list: " + e);
    return;
  }
  const has = (c) => channels[c] && channels[c].version;
  // Default to the stable release; fall back to whatever channel exists.
  if (!has(channel)) channel = has("release") ? "release" : (has("prerelease") ? "prerelease" : null);
  if (!channel) { Module.setStatus("Error: no web-demo builds are available yet."); return; }
  ENGINE_DIR = WEBDEMO_BASE + channel + "/" + channels[channel].version + "/";

  const sel = document.getElementById("channel");
  if (sel) {
    const labels = { release: "Latest release", prerelease: "Latest pre-release" };
    for (const c of ["release", "prerelease"]) {
      if (!has(c)) continue;
      const opt = document.createElement("option");
      opt.value = c;
      opt.textContent = (labels[c] || c) + " — " + channels[c].version;
      opt.selected = c === channel;
      sel.appendChild(opt);
    }
    sel.addEventListener("change", () => {
      const p = new URLSearchParams(location.search);
      p.set("channel", sel.value);
      location.search = p.toString();
    });
  }

  const s = document.createElement("script");
  s.async = true;
  s.src = ENGINE_DIR + "openlierox.js";
  s.onerror = () => Module.setStatus("Error: failed to load the engine from " + ENGINE_DIR);
  document.body.appendChild(s);
})();
</script>
{:/nomarkdown}
