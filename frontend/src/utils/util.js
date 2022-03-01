/**
 * 时间戳
 * @param {*} timestamp  时间戳
 */
const timestampToTime = (timestamp) => {
  let date = new Date(timestamp) //时间戳为10位需*1000，时间戳为13位的话不需乘1000
  let Y = date.getFullYear() + '-'
  let M =
    (date.getMonth() + 1 < 10 ?
      '0' + (date.getMonth() + 1) :
      date.getMonth() + 1) + '-'
  let D =
    (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) + ' '
  let h =
    (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':'
  let m =
    (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) +
    ':'
  let s =
    date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds()
  return Y + M + D + h + m + s
};

/**
 * 时间日期格式化
 * @param format
 * @returns {*}
 */
const dateFormats = (dateObj, format) => {
  let date = {
    'M+': dateObj.getMonth() + 1,
    'd+': dateObj.getDate(),
    'h+': dateObj.getHours(),
    'm+': dateObj.getMinutes(),
    's+': dateObj.getSeconds(),
    'q+': Math.floor((dateObj.getMonth() + 3) / 3),
    'S+': dateObj.getMilliseconds()
  };
  if (/(y+)/i.test(format)) {
    format = format.replace(RegExp.$1, (dateObj.getFullYear() + '').substr(4 - RegExp.$1.length))
  }
  for (let k in date) {
    if (new RegExp('(' + k + ')').test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length === 1
        ? date[k] : ('00' + date[k]).substr(('' + date[k]).length))
    }
  }
  return format
}

/**
 * 存储localStorage
 */
const setStore = (name, content) => {
  if (!name) return;
  if (typeof content !== 'string') {
    content = JSON.stringify(content);
  }
  window.localStorage.setItem(name, content);
}

/**
 * 获取localStorage
 */
const getStore = name => {
  if (!name) return;
  return window.localStorage.getItem(name);
}

/**
 * 删除localStorage
 */
const removeStore = name => {
  if (!name) return;
  window.localStorage.removeItem(name);
}

/**
 * 设置cookie
 **/
function setCookie(name, value, day) {
  let date = new Date();
  date.setDate(date.getDate() + day);
  document.cookie = name + '=' + value + ';expires=' + date;
};

/**
 * 获取cookie
 **/
function getCookie(name) {
  let reg = RegExp(name + '=([^;]+)');
  let arr = document.cookie.match(reg);
  if (arr) {
    return arr[1];
  } else {
    return '';
  }
};

/**
 * 删除cookie
 **/
function delCookie(name) {
  setCookie(name, null, -1);
};

//只能输入正整数和0
function limitNumInt(value) {
  value = value.replace(/\D/g, '');
  return value
}

//金额
function limitPriceType(value){
  var t = value.charAt(0);
  value = value.replace(/[^\d\.]/g, '');
  value = value.replace(/\.{2,}/g, '.');
  value = value.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
  value = value.replace(/^\./g, '');
  value = value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');
  return value
}

const handleDate = (date) => {
  let month = date.getMonth() + 1 < 10 ? `0${date.getMonth() + 1}` : date.getMonth() + 1
  let day = date.getDate() < 10 ? `0${date.getDate()}` : date.getDate()
  let hours = date.getHours() < 10 ? `0${date.getHours()}` : date.getHours()
  let minutes = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes()
  let seconds = date.getSeconds() < 10 ? `0${date.getSeconds()}` : date.getSeconds()
  return `${date.getFullYear()}-${month}-${day}`
}

// 时间处理
const handleTime = (date) => {
  let month = date.getMonth() + 1 < 10 ? `0${date.getMonth() + 1}` : date.getMonth() + 1
  let day = date.getDate() < 10 ? `0${date.getDate()}` : date.getDate()
  let hours = date.getHours() < 10 ? `0${date.getHours()}` : date.getHours()
  let minutes = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes()
  let seconds = date.getSeconds() < 10 ? `0${date.getSeconds()}` : date.getSeconds()
  return `${date.getFullYear()}-${month}-${day} ${hours}:${minutes}:${seconds}`
}
const commonVal = {
  isPhone: /^[1][3-9]\d{9}$/, // 手机号码
  isPrice: /^(^[1-9](\d+)?(\.\d{1,2})?$)|(^0$)|(^\d\.\d{1,2}$)$/, //money
  isTel: /^((0\d{2,3}-\d{7,8})|(1[3456789]\d{9}))$/, // 手机号码，座机
  isAgentAccount:/^[a-zA-Z0-9]+$/, //agentAccount
  isEmail: /^([a-zA-Z0-9]+[|_|.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[|_|.]?)*[a-zA-Z0-9]+.[a-zA-Z]{2,3}$/
}

function isShowBtn(url,moduleName, btnName) {
  let btnArr = sessionStorage.getItem('menuList')?JSON.parse(sessionStorage.getItem('menuList')):[];
  let isshow = false;
  for (var i = 0; i < btnArr.length; i++) {
    let item = btnArr[i];
    if (item.url == url && item.moduleName == moduleName && item.menuPermission && item.menuPermission.includes(btnName) ) {
      isshow = true;
      break;
    }
  }
  return isshow
}

// 图片上传根据名称排序
const  sortName = (v1, v2) => {
    let a = "" + v1;
    let b =  "" + v2;
    let reg = /[0-9]+/g;
    let lista = a.match(reg);
    let listb = b.match(reg);
    if (!lista || !listb) {
        return a.localeCompare(b);    }
    for (let i = 0, minLen = Math.min(lista.length, listb.length) ; i < minLen; i++) {
        //数字所在位置序号
        let indexa = a.indexOf(lista[i]);
        let indexb = b.indexOf(listb[i]);
        //数字前面的前缀
        let prefixa = a.substring(0, indexa);
        let prefixb = b.substring(0, indexb);
        //数字的string
        let stra = lista[i];
        let strb = listb[i];
        //数字的值
        let numa = parseInt(stra);
        let numb = parseInt(strb);
        //如果数字的序号不等或前缀不等，属于前缀不同的情况，直接比较
        if (indexa != indexb || prefixa != prefixb) {
            return a.localeCompare(b);
        }
        else {
            //数字的string全等
            if (stra === strb) {
                //如果是最后一个数字，比较数字的后缀
                if (i == minLen - 1) {
                    return a.substring(indexa).localeCompare(b.substring(indexb));
                }
                //如果不是最后一个数字，则循环跳转到下一个数字，并去掉前面相同的部分
                else {
                    a = a.substring(indexa + stra.length);
                    b = b.substring(indexa + stra.length);
                }
            }
            //如果数字的string不全等，但值相等
            else if (numa == numb) {
                //直接比较数字前缀0的个数，多的更小
                return strb.lastIndexOf(numb + '') - stra.lastIndexOf(numa + '');
            }
            else {
                return numa - numb;
            }
        }
    }
}
export {
  timestampToTime,
  dateFormats,
  setStore,
  getStore,
  removeStore,
  setCookie,
  getCookie,
  delCookie,
  limitNumInt,
  limitPriceType,
  handleDate,
  handleTime,
  commonVal,
  isShowBtn,
  sortName
}
