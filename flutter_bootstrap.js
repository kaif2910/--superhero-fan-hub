// Minimal bootstrap for local/dev hosting without build-time generated config.
// This avoids the "_flutter.buildConfig" error when flutter_bootstrap.js is missing.
window.addEventListener('load', function () {
  var scriptTag = document.createElement('script');
  scriptTag.src = 'main.dart.js';
  scriptTag.type = 'application/javascript';
  document.body.appendChild(scriptTag);
});
