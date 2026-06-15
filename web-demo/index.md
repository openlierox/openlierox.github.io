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
  assets at /web-demo/2026-06-15/, so SharedArrayBuffer is available.

  The page UI below is adapted from the engine's standalone index.html: the
  centred status overlay, the loadingDone/showStarting state machine, the
  olxOnEngineReady hook and the canvas aspect-ratio correction (for accurate
  mouse coords when the canvas is letter-boxed in fullscreen). The standalone's
  PWA bits — install button, manifest/apple-mobile meta tags and display-mode
  "standalone" handling — are intentionally omitted: they only make sense for
  the full-page app, not this in-page demo.

  The heavy binaries (openlierox.js / .wasm / .data, ~25 MB) are bundled in this
  repo at /web-demo/2026-06-15/ and loaded from the same origin via
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
#olx-game #fs-area{position:relative;width:640px;height:480px}
#olx-game #status{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);z-index:10000;pointer-events:none;text-align:center;max-width:90%;padding:10px 16px;border-radius:6px;background:rgba(0,0,0,.75);color:#ddd;font:14px/1.4 monospace}
#olx-game #status.err{background:#803030;color:#fff}
#olx-game #toolbar{padding:4px 0}
#olx-game #toolbar button{background:#2a2a2a;color:#ddd;border:1px solid #444;padding:4px 10px;font:12px system-ui,sans-serif;cursor:pointer;border-radius:3px}
#olx-game #toolbar button:hover{background:#3a3a3a}
#olx-game #canvas{width:640px;height:480px;display:block;background:#000;outline:0;image-rendering:pixelated}
#olx-game #fs-area:fullscreen{width:100vw;height:100vh;display:flex;align-items:center;justify-content:center;background:#000}
#olx-game #fs-area:fullscreen #canvas{width:min(100vw,100vh * 4 / 3);height:min(100vh,100vw * 3 / 4)}
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
  <div id="toolbar"><button id="fs-toggle" type="button">Enter fullscreen</button></div>
  <pre id="log"></pre>
</div>

<script>
const statusEl=document.getElementById("status"),logEl=document.getElementById("log");function appendLog(e,t){logEl.textContent+=e+"\n",logEl.scrollTop=logEl.scrollHeight,t&&logEl.classList.add("err")}let loadingDone=!1;function showStarting(){loadingDone||(loadingDone=!0,statusEl.style.display="",statusEl.classList.remove("err"),statusEl.textContent="Starting OpenLieroX…")}function exitFullscreenIfActive(){document.fullscreenElement&&document.exitFullscreen().catch((()=>{}))}window.olxOnEngineExit=e=>exitFullscreenIfActive(),window.olxOnEngineReady=()=>{statusEl.style.display="none"};var Module={locateFile:(p)=>"{{ '/web-demo/2026-06-15/' | relative_url }}"+p,canvas:(()=>{const e=document.getElementById("canvas");return e.addEventListener("webglcontextlost",(e=>{alert("WebGL context lost — please reload."),e.preventDefault()}),!1),e})(),print:e=>{Module.printAccept&&!Module.printAccept(e)||(console.log(e),appendLog(e,!1))},printErr:e=>{Module.printAccept&&!Module.printAccept(e)||(console.warn(e),appendLog(e,!0))},setStatus:e=>{if(/error|abort|exception/i.test(e=e||""))return statusEl.style.display="",statusEl.textContent=e,void statusEl.classList.add("err");if(loadingDone)return;const t=/^Downloading data\.\.\. \((\d+)\/(\d+)\)$/.exec(e);t&&t[1]===t[2]?showStarting():(statusEl.style.display=e?"":"none",statusEl.textContent=e,statusEl.classList.remove("err"))},monitorRunDependencies:e=>{0===e&&showStarting()},printAccept:e=>!/^(dependency:|still waiting on run dependencies|\(end of list\))/.test(e),onAbort:e=>{exitFullscreenIfActive(),Module.setStatus("Aborted: "+e)},onExit:()=>exitFullscreenIfActive()};Module.setStatus("Downloading…"),window.onerror=e=>Module.setStatus("Exception: "+e),(()=>{const e=Module.canvas,t=e.getBoundingClientRect.bind(e);e.getBoundingClientRect=function(){const e=t(),n=this.width,o=this.height;if(!(e.width&&e.height&&n&&o))return e;const l=n/o,s=e.width/e.height;if(Math.abs(s-l)<.001)return e;let a,i;return s>l?(i=e.height,a=i*l):(a=e.width,i=a/l),new DOMRect(e.left+(e.width-a)/2,e.top+(e.height-i)/2,a,i)}})(),window.addEventListener("keydown",(e=>{const t=e.target;if(!t||"INPUT"!==t.tagName&&"TEXTAREA"!==t.tagName&&!t.isContentEditable)if(!(e.altKey||e.ctrlKey||e.metaKey)||"ArrowLeft"!==e.code&&"ArrowRight"!==e.code&&"ArrowUp"!==e.code&&"ArrowDown"!==e.code)switch(e.code){case"ArrowLeft":case"ArrowRight":case"ArrowUp":case"ArrowDown":case"Space":case"Tab":case"Backspace":case"F1":e.preventDefault()}else e.preventDefault()}),!0),(()=>{const e=document.getElementById("fs-area"),t=document.getElementById("fs-toggle");document.fullscreenEnabled?(t.addEventListener("click",(()=>{document.fullscreenElement?document.exitFullscreen():e.requestFullscreen().catch((e=>appendLog("Fullscreen request failed: "+e,!0)))})),document.addEventListener("fullscreenchange",(()=>{t.textContent=document.fullscreenElement?"Exit fullscreen":"Enter fullscreen"}))):t.style.display="none"})()
</script>
<script async src="{{ '/web-demo/2026-06-15/openlierox.js' | relative_url }}"></script>
{:/nomarkdown}
