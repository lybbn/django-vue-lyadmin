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
