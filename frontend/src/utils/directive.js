import Vue from 'vue'

//只能输入正数(包含小数)和0
Vue.directive('limitPositiveNumber', {
	bind: function(el, binding, vNode) {
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
Vue.directive('limitPositiveInt', {
	bind: function(el, binding, vNode) {
		el.oninput=(e)=>{
			let value=e.target.value;
			value = value.replace(/\D/g, '');
			e.target.value=value;
			//手动触发input事件使v-model绑定的值更新
			e.target.dispatchEvent(new Event("input"));
		}
	}
})

//只能输入正整数并且不能大于9
Vue.directive('limitPositiveInt2', {
	bind: function(el, binding, vNode) {
		el.oninput=(e)=>{
			let value=e.target.value;
			value = value.replace(/\D/g, '');
			if(value > 9){value = 9}
			e.target.value=value;
			//手动触发input事件使v-model绑定的值更新
			e.target.dispatchEvent(new Event("input"));
		}
	}
})

Vue.directive('limitPositiveInt3', {
	bind: function(el, binding, vNode) {
		el.oninput=(e)=>{
			let value=e.target.value;
			value = value.replace(/\D/g, '');
			if(value > 10){value = 15}
			e.target.value=value;
			//手动触发input事件使v-model绑定的值更新
			e.target.dispatchEvent(new Event("input"));
		}
	}
})

//只能输入正数(最多两位小数)和0
Vue.directive('limitPositiveNumberFixed2', {
	bind: function(el, binding, vNode) {
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
Vue.directive('dialogDrag', {

  bind: function(el, binding, vNode) {
    // 弹框可拉伸最小宽高
    // console.log(el)
    const minWidth = 400
    const minHeight = 300
    // 初始非全屏
    let isFullScreen = false
    // 当前宽高
    let nowWidth = 0
    // eslint-disable-next-line no-unused-vars
    let nowHight = 0
    // 当前顶部高度
    let nowMarginTop = 0
    // 获取弹框头部（这部分可双击全屏）
    const dialogHeaderEl = el.querySelector('.el-dialog__header')
    // console.log(dialogHeaderEl)
    // 弹窗
    const dragDom = el.querySelector('.el-dialog')
    // 给弹窗加上overflow auto；不然缩小时框内的标签可能超出dialog；
    // console.log(dragDom)
    dragDom.style.overflow = 'auto'
    // 清除选择头部文字效果
    // dialogHeaderEl.onselectstart = new Function("return false");
    // 头部加上可拖动cursor
    dialogHeaderEl.style.cursor = 'move'
    // 获取原有属性 ie dom元素.currentStyle 火狐谷歌 window.getComputedStyle(dom元素, null);
    const sty = dragDom.currentStyle || window.getComputedStyle(dragDom, null)
    const moveDown = (e) => {
      // console.log(e)
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
      };
      document.onmousemove = function(e) {
        //console.log(e)
        // 通过事件委托，计算移动的距离
        const l = e.clientX - disX
        const t = e.clientY - disY
        // 移动当前元素
        dragDom.style.left = `${l + styL}px`
        dragDom.style.top = `${t + styT}px`
        // 将此时的位置传出去
        // binding.value({x:e.pageX,y:e.pageY})
      }
      document.onmouseup = function() {
        document.onmousemove = null
        document.onmouseup = null
      }
    }
    dialogHeaderEl.onmousedown = moveDown
    // 双击头部全屏效果
    dialogHeaderEl.ondblclick = () => {
      if (isFullScreen === false) {
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
        dragDom.style.height = 'auto'
        dragDom.style.width = nowWidth + 'px'
        dragDom.style.marginTop = nowMarginTop
        isFullScreen = false
        dialogHeaderEl.style.cursor = 'move'
        dialogHeaderEl.onmousedown = moveDown
      }
    }
    dragDom.onmousemove = function(e) {
      if (e.clientX > dragDom.offsetLeft + dragDom.clientWidth - 10 || dragDom.offsetLeft + 10 > e.clientX) {
        dragDom.style.cursor = 'w-resize'
      } else if (el.scrollTop + e.clientY > dragDom.offsetTop + dragDom.clientHeight - 10) {
        dragDom.style.cursor = 's-resize'
      } else {
        dragDom.style.cursor = 'default'
        dragDom.onmousedown = null
      }
      dragDom.onmousedown = (e) => {
        const clientX = e.clientX
        const clientY = e.clientY
        const elW = dragDom.clientWidth
        const elH = dragDom.clientHeight
        const EloffsetLeft = dragDom.offsetLeft
        const EloffsetTop = dragDom.offsetTop
        // dragDom.style.userSelect = 'none'
        const ELscrollTop = el.scrollTop
        // 判断点击的位置是不是为头部
        if (clientX > EloffsetLeft && clientX < EloffsetLeft + elW && clientY > EloffsetTop && clientY < EloffsetTop + 100) {
          // 如果是头部在此就不做任何动作，以上有绑定dialogHeaderEl.onmousedown = moveDown;
        } else {
          document.onmousemove = function(e) {
            e.preventDefault() // 移动时禁用默认事件
            // 左侧鼠标拖拽位置
            if (clientX > EloffsetLeft && clientX < EloffsetLeft + 10) {
              // 往左拖拽
              if (clientX > e.clientX) {
                dragDom.style.width = elW + (clientX - e.clientX) * 2 + 'px'
              }
              // 往右拖拽
              if (clientX < e.clientX) {
                if (dragDom.clientWidth < minWidth) {
                } else {
                  dragDom.style.width = elW - (e.clientX - clientX) * 2 + 'px'
                }
              }
            }
            // 右侧鼠标拖拽位置
            if (clientX > EloffsetLeft + elW - 10 && clientX < EloffsetLeft + elW) {
              // 往左拖拽
              if (clientX > e.clientX) {
                if (dragDom.clientWidth < minWidth) {
                } else {
                  dragDom.style.width = elW - (clientX - e.clientX) * 2 + 'px'
                }
              }
              // 往右拖拽
              if (clientX < e.clientX) {
                dragDom.style.width = elW + (e.clientX - clientX) * 2 + 'px'
              }
            }
            // 底部鼠标拖拽位置
            if (ELscrollTop + clientY > EloffsetTop + elH - 20 && ELscrollTop + clientY < EloffsetTop + elH) {
              // 往上拖拽
              if (clientY > e.clientY) {
                if (dragDom.clientHeight < minHeight) {

                } else {
                  dragDom.style.height = elH - (clientY - e.clientY) * 2 + 'px'
                }
              }
              // 往下拖拽
              if (clientY < e.clientY) {
                dragDom.style.height = elH + (e.clientY - clientY) * 2 + 'px'
              }
            }
          }
          // 拉伸结束
          document.onmouseup = function() {
            document.onmousemove = null
            document.onmouseup = null
          }
        }
      }
    }
  }

})
