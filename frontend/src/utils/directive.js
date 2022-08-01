//自定义指令插件：用法前面加上v-
export default {
  install:(app,options)=>{
	//只能输入正数(包含小数)和0
	app.directive('limitPositiveNumber', {
		mounted(el, binding) {
			el.oninput=(e)=>{
				let value=e.target.value;
				//先把非数字的都替换掉，除了数字和.
				value = value.replace(/[^\d\.]/g, '');
				//保证只有出现一个.而没有多个
				value = value.replace(/\.{2,}/g, '.');
				//保证.只出现一次，而不能出现两次以上
				value = value.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
				//必须保证第一个为数字而不是.
				value = value.replace(/^\./g, '');
				e.target.value=value;
				//手动触发input事件使v-model绑定的值更新
				e.target.dispatchEvent(new Event("input"));
			}
		}
	})
	//只能输入正整数和0
	app.directive('limitPositiveInt', {
		mounted(el, binding) {
			el.oninput=(e)=>{
				let value=e.target.value;
				value = value.replace(/\D/g, '');
				e.target.value=value;
				//手动触发input事件使v-model绑定的值更新
				e.target.dispatchEvent(new Event("input"));
			}
		}
	})
	//只能输入正数(最多两位小数)和0
	app.directive('limitPositiveNumberFixed2', {
		mounted(el, binding) {
			el.oninput=(e)=>{
				let value=e.target.value;
				var t = value.charAt(0);
				//先把非数字的都替换掉，除了数字和.
				value = value.replace(/[^\d\.]/g, '');
				//保证只有出现一个.而没有多个
				value = value.replace(/\.{2,}/g, '.');
				//保证.只出现一次，而不能出现两次以上
				value = value.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
				//必须保证第一个为数字而不是.
				value = value.replace(/^\./g, '');
				value = value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');
				e.target.value=value;
				//手动触发input事件使v-model绑定的值更新
				e.target.dispatchEvent(new Event("input"));
			}
		}
	})
    // v-dialogDrag: 弹窗拖拽和双击放大属性 （重点！！！ 给模态框添加这个属性模态框就能拖拽了）
    // :destroy-on-close="true" 会导致关闭打开后拖拽事件失效
	app.directive('dialogDrag', {
	  updated(el,binding) {
      //弹框可拉伸最小宽高
      let minWidth = 400
      let minHeight = 300
      //初始非全屏
      let isFullScreen = false
      //当前宽高
      let nowWidth = 0
      let nowHight = 0
      //当前顶部高度
      let nowMarginTop = 0
      //获取弹框头部（这部分可双击全屏）
      const dialogHeaderEl = el.querySelector('.el-dialog__header')
      //弹窗
      const dragDom = el.querySelector('.el-dialog')
      // console.log(dragDom,'xxxxxxx')
      // console.log(dialogHeaderEl,'yyyyyyyy')
      if(dialogHeaderEl && dragDom){
          // dragBody.style.height = dragDom.clientHeight - 102 + 'px'
      //给弹窗加上overflow auto；不然缩小时框内的标签可能超出dialog；
      dragDom.style.overflow = 'auto'
      //清除选择头部文字效果
      dialogHeaderEl.onselectstart = new Function('return false')
      //头部加上可拖动cursor
      dialogHeaderEl.style.cursor = 'move'

      // 获取原有属性 ie dom元素.currentStyle 火狐谷歌 window.getComputedStyle(dom元素, null);
      const sty = dragDom.currentStyle || window.getComputedStyle(dragDom, null)

      let moveDown = (e) => {
        // 鼠标按下，计算当前元素距离可视区的距离
        const disX = e.clientX - dialogHeaderEl.offsetLeft
        const disY = e.clientY - dialogHeaderEl.offsetTop

        // 获取到的值带px 正则匹配替换
        let styL, styT

        // 注意在ie中 第一次获取到的值为组件自带50% 移动之后赋值为px
        if (sty.left.includes('%')) {
          styL = +document.body.clientWidth * (+sty.left.replace(/%/g, '') / 100)
          styT = +document.body.clientHeight * (+sty.top.replace(/%/g, '') / 100)
        } else {
          styL = +sty.left.replace(/px/g, '')
          styT = +sty.top.replace(/px/g, '')
        }

        document.onmousemove = function (e) {
          // 通过事件委托，计算移动的距离
          const l = e.clientX - disX
          const t = e.clientY - disY

          // 移动当前元素
          dragDom.style.left = `${l + styL}px`
          dragDom.style.top = `${t + styT}px`

          //将此时的位置传出去
          //binding.value({x:e.pageX,y:e.pageY})
        }

        document.onmouseup = function () {
          document.onmousemove = null
          document.onmouseup = null
        }
      }
      dialogHeaderEl.onmousedown = moveDown
      //双击头部效果
      dialogHeaderEl.ondblclick = () => {
        let elOverlay = el.querySelector('.el-overlay')
        let dialogBody = el.querySelector('.el-dialog__body')
        if (isFullScreen == false) {
            nowHight = dragDom.clientHeight
            nowWidth = dragDom.clientWidth
            nowMarginTop = dragDom.style.marginTop
            dragDom.style.left = 0
            dragDom.style.top = 0
            dragDom.style.height = '100VH'
            dragDom.style.width = '100VW'
            dragDom.style.marginTop = 0
            isFullScreen = true
            dialogHeaderEl.style.cursor = 'initial'
            dialogHeaderEl.onmousedown = null
        } else {
          dragDom.style.height = nowHight + 'px'
            dragDom.style.margin = 'auto'
            dragDom.style.width = nowWidth + 'px'
            dragDom.style.marginTop = nowMarginTop
            isFullScreen = false
            dialogHeaderEl.style.cursor = 'move'
            dialogHeaderEl.onmousedown = moveDown
        }
      }

      //拉伸(右下方)
      let resizeEl = document.createElement('div')
      dragDom.appendChild(resizeEl)
      //在弹窗右下角加上一个10-10px的控制块
      resizeEl.style.cursor = 'se-resize'
      resizeEl.style.position = 'absolute'
      resizeEl.style.height = '6px'
      resizeEl.style.width = '6px'
      resizeEl.style.right = '0px'
      resizeEl.style.bottom = '0px'
      resizeEl.style.zIndex = '99'
      //鼠标拉伸弹窗
      resizeEl.onmousedown = (e) => {
        // 记录初始x位置
        let clientX = e.clientX
        // 鼠标按下，计算当前元素距离可视区的距离
        let disX = e.clientX - resizeEl.offsetLeft
        let disY = e.clientY - resizeEl.offsetTop

        document.onmousemove = function (e) {
          let dialogBody = el.querySelector('.el-dialog__body')
          dialogBody.style.height = dragDom.offsetHeight - 102 + 'px'
          e.preventDefault() // 移动时禁用默认事件
          // 通过事件委托，计算移动的距离
          let x = e.clientX - disX + (e.clientX - clientX) + 5 //这里 由于elementUI的dialog控制居中的，所以水平拉伸效果是双倍
          let y = e.clientY - disY + 5
          //比较是否小于最小宽高
          dragDom.style.width = x > minWidth ? `${x}px` : minWidth + 'px'
          dragDom.style.height = y > minHeight ? `${y}px` : minHeight + 'px'
        }
        //拉伸结束
        document.onmouseup = function () {
          document.onmousemove = null
          document.onmouseup = null
        }
      }

      //拉伸(右边)
      let resizeElR = document.createElement('div')
      dragDom.appendChild(resizeElR)
      //在弹窗右下角加上一个10-10px的控制块
      resizeElR.style.cursor = 'w-resize'
      resizeElR.style.position = 'absolute'
      resizeElR.style.height = '100%'
      resizeElR.style.width = '10px'
      resizeElR.style.right = '0px'
      resizeElR.style.top = '0px'
      //鼠标拉伸弹窗
      resizeElR.onmousedown = (e) => {
        let elW = dragDom.clientWidth
        let EloffsetLeft = dragDom.offsetLeft
        // 记录初始x位置
        let clientX = e.clientX
        document.onmousemove = function (e) {
          e.preventDefault() // 移动时禁用默认事件
          //右侧鼠标拖拽位置
          if (clientX > EloffsetLeft + elW - 10 && clientX < EloffsetLeft + elW) {
            //往左拖拽
            if (clientX > e.clientX) {
              if (dragDom.clientWidth < minWidth) {
                null
              } else {
                dragDom.style.width = elW - (clientX - e.clientX) * 2 + 'px'
              }
            }
            //往右拖拽
            if (clientX < e.clientX) {
              dragDom.style.width = elW + (e.clientX - clientX) * 2 + 'px'
            }
          }
        }
        //拉伸结束
        document.onmouseup = function () {
          document.onmousemove = null
          document.onmouseup = null
        }
      }

      //拉伸(左边)
      let resizeElL = document.createElement('div')
      dragDom.appendChild(resizeElL)
      //在弹窗右下角加上一个10-10px的控制块
      resizeElL.style.cursor = 'w-resize'
      resizeElL.style.position = 'absolute'
      resizeElL.style.height = '100%'
      resizeElL.style.width = '10px'
      resizeElL.style.left = '0px'
      resizeElL.style.top = '0px'
      //鼠标拉伸弹窗
      resizeElL.onmousedown = (e) => {
        let elW = dragDom.clientWidth
        let EloffsetLeft = dragDom.offsetLeft
        // 记录初始x位置
        let clientX = e.clientX
        document.onmousemove = function (e) {
          e.preventDefault() // 移动时禁用默认事件
          //左侧鼠标拖拽位置
          if (clientX > EloffsetLeft && clientX < EloffsetLeft + 10) {
            //往左拖拽
            if (clientX > e.clientX) {
              dragDom.style.width = elW + (clientX - e.clientX) * 2 + 'px'
            }
            //往右拖拽
            if (clientX < e.clientX) {
              if (dragDom.clientWidth < minWidth) {
                null
              } else {
                dragDom.style.width = elW - (e.clientX - clientX) * 2 + 'px'
              }
            }
          }
        }
        //拉伸结束
        document.onmouseup = function () {
          document.onmousemove = null
          document.onmouseup = null
        }
      }

      // 拉伸(下边)
      let resizeElB = document.createElement('div')
      dragDom.appendChild(resizeElB)
      //在弹窗右下角加上一个10-10px的控制块
      resizeElB.style.cursor = 'n-resize'
      resizeElB.style.position = 'absolute'
      resizeElB.style.height = '10px'
      resizeElB.style.width = '100%'
      resizeElB.style.left = '0px'
      resizeElB.style.bottom = '0px'
      //鼠标拉伸弹窗
      resizeElB.onmousedown = (e) => {
        // console.log(body)
        // let EloffsetTop = dragDom.offsetTop
        // let elOverlay = el.querySelector('.el-overlay')
        // let ELscrollTop = el.scrollTop
        let clientY = e.clientY
        let elH = dragDom.clientHeight
        document.onmousemove = function (e) {
          let dialogBody = el.querySelector('.el-dialog__body')
          dialogBody.style.height = dragDom.offsetHeight - 102 + 'px'
          e.preventDefault() // 移动时禁用默认事件
          //底部鼠标拖拽位置
          // if (ELscrollTop + clientY > EloffsetTop + elH - 20 && ELscrollTop + clientY < EloffsetTop + elH) {
          //往上拖拽
          if (clientY > e.clientY) {
            if (dragDom.clientHeight < minHeight) {
              null
            } else {
              dragDom.style.height = elH - (clientY - e.clientY) + 'px'
            }
          }
          //往下拖拽
          if (clientY < e.clientY) {
            dragDom.style.height = elH + (e.clientY - clientY) + 'px'
          }
          // }
        }
        //拉伸结束
        document.onmouseup = function () {
          document.onmousemove = null
          document.onmouseup = null
        }
      }
      }
    },

	})
  }

}