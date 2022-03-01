
(function () {
  // 1. 获取必要的DOM元素
  var oTips = document.querySelector(".tips");
  var oBrowserTips = document.querySelector(".browser-tips");
  var oEnvImgForiOS = document.querySelector(".icon-env.ios");
  var oEnvImgForAndroid = document.querySelector(".icon-env.android");
  var oButtonDownload = document.querySelector(".download-button");
  var oButtonOpenApp = document.querySelector(".open-tips");
  var oDialog = document.querySelector(".dialog");
  // 2. 常量值
  var env = getEnv();
  var isAnimating = false;
  var SCHEME_URI = "d-point-life://www.lybbn.com/switch?index=0";
  var downloadUrlForiOS = "https://itunes.apple.com/cn/app/id12346546xx";
  var downloadUrlForAndroid = "";
  // 3. 控制默认显示
  switch (env) {
    // 微信环境，提示浏览器打开
    case "weixin":
      oTips.classList.add("show");
      break;
    // iOS环境，展示图标和下载按钮
    case "ios":
      oEnvImgForiOS.classList.add("show");
      oButtonOpenApp.classList.add("show");
      break;
    // Android环境，展示图标和下载按钮
    case "android":
      oEnvImgForAndroid.classList.add("show");
      oButtonOpenApp.classList.add("show");
      break;
    case "unknown":
      oBrowserTips.classList.add("show");
      break;
  }

  // 4. 事件 --- 唤醒APP
  oButtonOpenApp.addEventListener(
    "click",
    function () {
      if (["ios", "android"].indexOf(env) !== -1) {
        window.location.href = SCHEME_URI;
      }
    },
    false
  );
  // 5. 事件 --- 下载APP
  oButtonDownload.addEventListener(
    "click",
    function () {
      switch (env) {
        case "weixin":
          if (isAnimating) {
            return;
          }
          isAnimating = true;
          oTips.classList.add("ani");
          var t = setTimeout(function () {
            isAnimating = false;
            oTips.classList.remove("ani");
            clearTimeout(t);
          }, 1000);
          break;
        case "android":
          window.location.href = downloadUrlForAndroid;
          break;
        case "ios":
          window.location.href = downloadUrlForiOS;
          // # 即将开放提示
          /*
          oDialog.classList.add("show");
          var t = setTimeout(function () {
            oDialog.classList.remove("show");
            clearTimeout(t);
          }, 1000);*/
          break;
        case "unknown":
          alert("请在移动端（手机）浏览器打开此页面");
          break;
      }
    },
    false
  );
})();
