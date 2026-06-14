---
layout: default
title: Web Demo
permalink: /web-demo/
---
<!--
  The WebAssembly build of OpenLieroX is multi-threaded (pthreads /
  SharedArrayBuffer), which requires the page to be "cross-origin isolated"
  (COOP: same-origin + COEP). GitHub Pages can't send those headers, so we
  load coi-serviceworker.js, which installs a service worker that adds them.
  Its /web-demo/ scope isolates THIS page and also covers the engine
  assets at /web-demo/2026-05-06/, so SharedArrayBuffer is available.

  The page UI below is copied from the engine's standalone index.html. The
  heavy binaries (openlierox.js / .wasm / .data, ~25 MB) are bundled in this
  repo at /web-demo/2026-05-06/ and loaded from the same origin via
  Module.locateFile and the async <script src> at the end.
-->
<script src="{{ '/web-demo/coi-serviceworker.js' | relative_url }}"></script>

## Play OpenLieroX in your web browser

The web version of OpenLieroX is just a demo. It has no network multiplayer and
has worse performance than running the game locally.

For the full experience [Download the game]({{ '/downloads/' | relative_url }}).

{::nomarkdown}
<style>
#olx-game{display:flex;flex-direction:column;align-items:center;background:#111;color:#ddd;font-family:system-ui,sans-serif;border:1px solid #444;margin:0 auto;max-width:960px}
#olx-game #status{padding:6px 10px;background:#222;font:13px/1.4 monospace;align-self:stretch}
#olx-game #status.err{background:#803030;color:#fff}
#olx-game #toolbar{padding:4px 0}
#olx-game #toolbar button{background:#2a2a2a;color:#ddd;border:1px solid #444;padding:4px 10px;font:12px system-ui,sans-serif;cursor:pointer;border-radius:3px}
#olx-game #toolbar button:hover{background:#3a3a3a}
#olx-game #canvas{width:640px;height:480px;display:block;background:#000;outline:0;image-rendering:pixelated}
#olx-game #canvas:fullscreen{width:100vw;height:100vh;object-fit:contain}
#olx-game #log{max-height:25vh;overflow:auto;padding:4px 10px;background:#181818;font:12px/1.3 monospace;white-space:pre-wrap;align-self:stretch}
#olx-game #log.err{color:#f99}
</style>

<div id="olx-game">
  <div id="status">Loading OpenLieroX…</div>
  <div id="toolbar"><button id="fs-toggle" type="button">Enter fullscreen</button></div>
  <canvas id="canvas" width="640" height="480" tabindex="-1" oncontextmenu="event.preventDefault()"></canvas>
  <pre id="log"></pre>
</div>

<script>
const statusEl=document.getElementById("status"),logEl=document.getElementById("log");function appendLog(e,t){logEl.textContent+=e+"\n",logEl.scrollTop=logEl.scrollHeight,t&&logEl.classList.add("err")}function exitFullscreenIfActive(){document.fullscreenElement&&document.exitFullscreen().catch((()=>{}))}window.olxOnEngineExit=e=>exitFullscreenIfActive();var Module={locateFile:(p)=>"{{ '/web-demo/2026-05-06/' | relative_url }}"+p,canvas:(()=>{const e=document.getElementById("canvas");return e.addEventListener("webglcontextlost",(e=>{alert("WebGL context lost — please reload."),e.preventDefault()}),!1),e})(),print:e=>{Module.printAccept&&!Module.printAccept(e)||(console.log(e),appendLog(e,!1))},printErr:e=>{Module.printAccept&&!Module.printAccept(e)||(console.warn(e),appendLog(e,!0))},setStatus:e=>{e||(e=""),statusEl.textContent=e||"Running.",statusEl.classList.toggle("err",/error|abort/i.test(e))},totalDependencies:0,monitorRunDependencies:e=>{Module.totalDependencies=Math.max(Module.totalDependencies,e),Module.setStatus(e?`Preparing… (${Module.totalDependencies-e}/${Module.totalDependencies})`:"All downloads complete.")},printAccept:e=>!/^(dependency:|still waiting on run dependencies|\(end of list\))/.test(e),onAbort:e=>{exitFullscreenIfActive(),Module.setStatus("Aborted: "+e)},onExit:()=>exitFullscreenIfActive()};Module.setStatus("Downloading…"),window.onerror=e=>Module.setStatus("Exception: "+e),window.addEventListener("keydown",(e=>{const t=e.target;if(!t||"INPUT"!==t.tagName&&"TEXTAREA"!==t.tagName&&!t.isContentEditable)if(!(e.altKey||e.ctrlKey||e.metaKey)||"ArrowLeft"!==e.code&&"ArrowRight"!==e.code&&"ArrowUp"!==e.code&&"ArrowDown"!==e.code)switch(e.code){case"ArrowLeft":case"ArrowRight":case"ArrowUp":case"ArrowDown":case"Space":case"Tab":case"Backspace":case"F1":e.preventDefault()}else e.preventDefault()}),!0),(()=>{const e=document.getElementById("canvas"),t=document.getElementById("fs-toggle");t.addEventListener("click",(()=>{document.fullscreenElement?document.exitFullscreen():e.requestFullscreen().catch((e=>appendLog("Fullscreen request failed: "+e,!0)))})),document.addEventListener("fullscreenchange",(()=>{t.textContent=document.fullscreenElement?"Exit fullscreen":"Enter fullscreen"}))})()
</script>
<script async src="{{ '/web-demo/2026-05-06/openlierox.js' | relative_url }}"></script>
{:/nomarkdown}
