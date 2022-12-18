import SvgIcon from '@/components/icons/SvgIcon'

const registerSvgIcon = (app) => {
  app.component('svg-icon', SvgIcon) // 注册全局组件

  const req = require.context('./svg', false, /\.svg$/);
  const requireAll = requireContext => requireContext.keys().map(requireContext);
  requireAll(req);
}

export default registerSvgIcon;