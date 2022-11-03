
function getEnv() {
  var _userAgent = window.navigator.userAgent;
  if (/MicroMessenger/i.test(_userAgent)) {
    return "weixin";
  } else if (/Linux|Android/i.test(_userAgent)) {
    return "android";
  } else if (/iPhone/i.test(_userAgent)) {
    return "ios";
  } else {
    return "unknown";
  }
}

function setEnvImg(element, env) {
  switch (env) {
    case "android":
      element.src = "images/icon_android_1.2554488.lllxs2download-app.png";
      break;
    case "ios":
      element.src = "images/icon_ios_1.2554488.lllxs2download-app.png";
      break;
    default:
  }
}
