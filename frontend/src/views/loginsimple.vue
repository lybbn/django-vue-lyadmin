<template>
  <div class="login-wrap">
    <el-form label-position="left" :model="ruleForm" :rules="rules" ref="ruleForm" label-width="0px" class="demo-ruleForm login-container">
      <h3 class="title">用户登录</h3>
      <el-form-item prop="username">
        <el-input type="text" size="large" v-model.trim="ruleForm.username" auto-complete="off" placeholder="账号" maxlength="60">
              <template #prepend>
                  <el-icon><user-filled /></el-icon>
              </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input type="password" size="large" v-model.trim="ruleForm.password" auto-complete="off" placeholder="密码" maxlength="60">
            <template #prepend>
              <el-icon><lock /></el-icon>
            </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="captcha">
        <el-input type="text"  size="large" v-model.trim="ruleForm.captcha" auto-complete="off" @keyup.enter="submitForm('ruleForm')"  placeholder="验证码">
             <template #prepend>
                <el-icon ><circle-check /></el-icon>
              </template>
              <template #append>
                <img class="login-code" :src="image_base" @click="getCaptcha"/>
              </template>
        </el-input>
      </el-form-item>
      <el-checkbox class="remember" v-model="rememberpassword">记住密码</el-checkbox>
      <el-form-item style="width:100%;margin-top: 10px">
        <el-button type="primary" size="large" :loading="loadingLg" style="width:100%;" @click="submitForm('ruleForm')">登录</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script >
  import {login,apiSystemWebRouter,getCaptcha} from '../api/api'
  import {systemTree} from "@/utils/menuTree.js"
  import {delCookie, getCookie, setCookie} from '../utils/util'
  import {useMutitabsStore} from "../store/mutitabs";
  import {setStorage,getStorage} from '@/utils/util'
  export default {
    name: 'login',
    setup(){
        const mutitabsstore = useMutitabsStore()
        return { mutitabsstore}
    },
    data() {
      return {
        loadingLg:false,
        logining: false,
        rememberpassword: false,
        ruleForm: {
            username: '',
            password: '',
            captcha:'',
            captchaKey: null,
        },
        loginFlag:false,
        rules: {
            username: [{required: true, message: '请输入账号', trigger: 'blur'}],
            password: [{required: true, message: '请输入密码', trigger: 'blur'}],
            captcha: [{required: true, message: '请输入验证码', trigger: 'blur'}],
        },
        image_base: null,
        allmenu:[]
      }
    },
    created() {
        //动态添加该页面meta viewport 手机适配
        if(document.querySelector("meta[name='viewport']")){
            document.querySelector("meta[name='viewport']")["content"] = "width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no"
        }
        //请求数据
        this.getuserpassword()
        this.getCaptcha()
      },
      beforeRouteLeave(to, form, next){
          //离开页面去除动态添加该页面meta viewport 手机适配
          document.querySelector("meta[name='viewport']")["content"] = this.getCurrentWith()
          next()
      },
      methods: {
        getCurrentWith(){
            var designWidth = 375;
            var deviceWidth = parseInt(window.screen.width) || parseInt(document.documentElement.clientWidth);  //获取当前设备的屏幕宽度
            // var deviceScale = deviceWidth/designWidth;
            var deviceScale = 0.6;
            var ua = navigator.userAgent;
            //获取当前设备类型（安卓或苹果）

            if (ua && /Android (\d+.\d+)/.test(ua)) {
                // +",user-scalable=no"
                return "width=680,initial-scale="+deviceScale+",minimum-scale="+deviceScale+",maximum-scale="+deviceScale;
            }
            else if (ua && /iPhone|ipad|ipod|ios/.test(ua)){
                return "width=680,initial-scale="+deviceScale+",minimum-scale="+deviceScale+",maximum-scale="+deviceScale;
            }
            else {
                return '';
            }
        },
      // 获取用户名密码
      // 获取菜单
      getMenu() {
        this.menuTitle=''
        this.allmenu=[]
        this.loadingLg=true
        apiSystemWebRouter().then(res=>{
          if(res.code == 2000) {
            let menuTree = []
            if(res.data.data.length > 0) {
              let childrenList = res.data.data.filter(item=> item.parent && item.visible == 1)
              let parentList = res.data.data.filter(item=> !item.parent && item.visible == 1)
              if(parentList.length >0) {
                parentList.forEach(item=>{
                  let menuTreeChildren=[]
                  let children = childrenList.filter(itema=>itema.parent == item.id)
                  let children2 = childrenList.filter((item)=>{
                    return children.every((item1)=>{
                        return item.path != item1.path;
                    })
                  })
                  children.forEach(itemb=>{
                    let cmenuTreeChildren=[]
                    let cchildren = children2.filter(itemc=>itemc.parent == itemb.id)
                    cchildren.forEach(itemd=>{
                        cmenuTreeChildren.push(({
                          text:itemd.name,
                          id:itemd.id,
                          attributes:{
                            url:itemd.web_path,
                            icon:itemd.icon
                          },
                          hasChildren: false,
                          hasParent:true
                        }))
                    })
                    let chasChildren = false
                    if(cmenuTreeChildren.length>0){
                        chasChildren = true
                    }
                    menuTreeChildren.push(({
                      text:itemb.name,
                      id:itemb.id,
                      attributes:{
                        url:itemb.web_path,
                        icon:itemb.icon
                      },
                      children:cmenuTreeChildren,
                      hasChildren: chasChildren,
                      hasParent:true,
                    }))
                  })
                  menuTree.push({
                    text:item.name,
                    id:item.id,
                    attributes:{
                      url:children.length >0 ? children[0].web_path :item.web_path,
                      icon:item.icon
                    },
                    hasChildren: children.length >0,
                    hasParent:false,
                    children:menuTreeChildren,
                  })
                  item.children=[...children]
                })
              }

              // 操作权限管控
              let menuList=[]
              res.data.data.forEach(item=>{
                //console.log(item,'item---- 菜单权限---')
                menuList.push({
                  url:item.web_path,
                  moduleName:item.name,
                  menuPermission:item.menuPermission
                })
              })
              setStorage('menuList', JSON.stringify(menuList))
            }
            // console.log(menuTree,'menuTree-----')
            this.allmenu =  menuTree
            if(this.allmenu.length >0) {
              this.$nextTick(()=>{
                this.$router.replace({path: `/${this.allmenu[0].attributes.url}`})
              })
            } else {
               this.mutitabsstore.logout('false')
               this.$router.push({path: '/login'})
               sessionStorage.clear()
               localStorage.clear()
               this.loadingLg=false
               this.$message.warning('暂无授权任何菜单权限~')
            }

            setStorage('allmenu', JSON.stringify(this.allmenu))
            //优化首次登录第一个标签显示问题
            let tabsPage = ""
            let TabsValue = ""
            if(menuTree[0].hasChildren){
                tabsPage = [{"title":menuTree[0].children[0].text,"name":menuTree[0].children[0].attributes.url}]
                TabsValue = menuTree[0].children[0].attributes.url
            }else{
                tabsPage = [{"title":menuTree[0].text,"name":menuTree[0].attributes.url}]
                TabsValue = menuTree[0].attributes.url
            }
            this.mutitabsstore.firstTabs([tabsPage,TabsValue])
            this.$forceUpdate()
          } else {
            this.$message.warning(res.msg)
          }

          this.loadingLg=false
        })

        this.$forceUpdate()
      },


      getuserpassword() {
        if (getCookie('username') != '' && getCookie('password') != '') {
          this.ruleForm.username = getCookie('username')
          this.ruleForm.password = getCookie('password')
          this.rememberpassword = true
        }
      },

      /**
       * 获取验证码
       */
      getCaptcha () {
        getCaptcha().then((ret) => {
          this.ruleForm.captcha = null
          this.ruleForm.captchaKey = ret.data.data.key
          this.image_base = ret.data.data.image_base
        })
      },

      //获取info列表
      submitForm(formName) {

        this.$refs[formName].validate(valid => {
          if (valid) {
            this.loadingLg = true
            login(this.ruleForm).then(async res => {
              this.loadingLg = false
              if (res.code === 2000) {
                if (this.rememberpassword) {
                  //保存帐号到cookie，有效期7天
                  await setCookie('username', this.ruleForm.username, 7)
                  //保存密码到cookie，有效期7天
                  await setCookie('password', this.ruleForm.password, 7)
                } else {
                  await delCookie('username')
                  await delCookie('password')
                }
                this.mutitabsstore.setLogintoken(res.data.access)
                this.mutitabsstore.setUserName(res.data.name)
                this.mutitabsstore.setUserId(res.data.userId)
                this.mutitabsstore.setRefresh(res.data.refresh)
                this.getMenu()
              } else {
                this.getCaptcha()
                this.$message.error(res.msg)
                return false
              }
            })
          } else {
            this.$message.error('请输入用户名密码/验证码！')
            return false
          }
        })

      }
    }
  }
</script>

<style lang="scss">
  .login-wrap {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    box-sizing: border-box;
    width: 100%;
    height: 100%;
    background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+Cjxzdmcgd2lkdGg9IjEzNjFweCIgaGVpZ2h0PSI2MDlweCIgdmlld0JveD0iMCAwIDEzNjEgNjA5IiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgogICAgPCEtLSBHZW5lcmF0b3I6IFNrZXRjaCA0Ni4yICg0NDQ5NikgLSBodHRwOi8vd3d3LmJvaGVtaWFuY29kaW5nLmNvbS9za2V0Y2ggLS0+CiAgICA8dGl0bGU+R3JvdXAgMjE8L3RpdGxlPgogICAgPGRlc2M+Q3JlYXRlZCB3aXRoIFNrZXRjaC48L2Rlc2M+CiAgICA8ZGVmcz48L2RlZnM+CiAgICA8ZyBpZD0iQW50LURlc2lnbi1Qcm8tMy4wIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4KICAgICAgICA8ZyBpZD0i6LSm5oi35a+G56CB55m75b2VLeagoemqjCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTc5LjAwMDAwMCwgLTgyLjAwMDAwMCkiPgogICAgICAgICAgICA8ZyBpZD0iR3JvdXAtMjEiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDc3LjAwMDAwMCwgNzMuMDAwMDAwKSI+CiAgICAgICAgICAgICAgICA8ZyBpZD0iR3JvdXAtMTgiIG9wYWNpdHk9IjAuOCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNzQuOTAxNDE2LCA1NjkuNjk5MTU4KSByb3RhdGUoLTcuMDAwMDAwKSB0cmFuc2xhdGUoLTc0LjkwMTQxNiwgLTU2OS42OTkxNTgpIHRyYW5zbGF0ZSg0LjkwMTQxNiwgNTI1LjE5OTE1OCkiPgogICAgICAgICAgICAgICAgICAgIDxlbGxpcHNlIGlkPSJPdmFsLTExIiBmaWxsPSIjQ0ZEQUU2IiBvcGFjaXR5PSIwLjI1IiBjeD0iNjMuNTc0ODc5MiIgY3k9IjMyLjQ2ODM2NyIgcng9IjIxLjc4MzA0NzkiIHJ5PSIyMS43NjYwMDgiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0zIiBmaWxsPSIjQ0ZEQUU2IiBvcGFjaXR5PSIwLjU5OTk5OTk2NCIgY3g9IjUuOTg3NDY0NzkiIGN5PSIxMy44NjY4NjAxIiByeD0iNS4yMTczOTEzIiByeT0iNS4yMTMzMDk5NyI+PC9lbGxpcHNlPgogICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0zOC4xMzU0NTE0LDg4LjM1MjAyMTUgQzQzLjg5ODQyMjcsODguMzUyMDIxNSA0OC41NzAyMzQsODMuNjgzODY0NyA0OC41NzAyMzQsNzcuOTI1NDAxNSBDNDguNTcwMjM0LDcyLjE2NjkzODMgNDMuODk4NDIyNyw2Ny40OTg3ODE2IDM4LjEzNTQ1MTQsNjcuNDk4NzgxNiBDMzIuMzcyNDgwMSw2Ny40OTg3ODE2IDI3LjcwMDY2ODgsNzIuMTY2OTM4MyAyNy43MDA2Njg4LDc3LjkyNTQwMTUgQzI3LjcwMDY2ODgsODMuNjgzODY0NyAzMi4zNzI0ODAxLDg4LjM1MjAyMTUgMzguMTM1NDUxNCw4OC4zNTIwMjE1IFoiIGlkPSJPdmFsLTMtQ29weSIgZmlsbD0iI0NGREFFNiIgb3BhY2l0eT0iMC40NSI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik02NC4yNzc1NTgyLDMzLjE3MDQ5NjMgTDExOS4xODU4MzYsMTYuNTY1NDkxNSIgaWQ9IlBhdGgtMTIiIHN0cm9rZT0iI0NGREFFNiIgc3Ryb2tlLXdpZHRoPSIxLjczOTEzMDQzIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8cGF0aCBkPSJNNDIuMTQzMTcwOCwyNi41MDAyNjgxIEw3LjcxMTkwMTYyLDE0LjU2NDA3MDIiIGlkPSJQYXRoLTE2IiBzdHJva2U9IiNFMEI0QjciIHN0cm9rZS13aWR0aD0iMC43MDI2Nzg5NjQiIG9wYWNpdHk9IjAuNyIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiBzdHJva2UtZGFzaGFycmF5PSIxLjQwNTM1Nzg5OTg3MzE1MywyLjEwODAzNjk1MzQ2OTk4MSI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik02My45MjYyMTg3LDMzLjUyMTU2MSBMNDMuNjcyMTMyNiw2OS4zMjUwOTUxIiBpZD0iUGF0aC0xNSIgc3Ryb2tlPSIjQkFDQUQ5IiBzdHJva2Utd2lkdGg9IjAuNzAyNjc4OTY0IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiIHN0cm9rZS1kYXNoYXJyYXk9IjEuNDA1MzU3ODk5ODczMTUzLDIuMTA4MDM2OTUzNDY5OTgxIj48L3BhdGg+CiAgICAgICAgICAgICAgICAgICAgPGcgaWQ9Ikdyb3VwLTE3IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMjYuODUwOTIyLCAxMy41NDM2NTQpIHJvdGF0ZSgzMC4wMDAwMDApIHRyYW5zbGF0ZSgtMTI2Ljg1MDkyMiwgLTEzLjU0MzY1NCkgdHJhbnNsYXRlKDExNy4yODU3MDUsIDQuMzgxODg5KSIgZmlsbD0iI0NGREFFNiI+CiAgICAgICAgICAgICAgICAgICAgICAgIDxlbGxpcHNlIGlkPSJPdmFsLTQiIG9wYWNpdHk9IjAuNDUiIGN4PSI5LjEzNDgyNjUzIiBjeT0iOS4xMjc2ODA3NiIgcng9IjkuMTM0ODI2NTMiIHJ5PSI5LjEyNzY4MDc2Ij48L2VsbGlwc2U+CiAgICAgICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0xOC4yNjk2NTMxLDE4LjI1NTM2MTUgQzE4LjI2OTY1MzEsMTMuMjE0MjgyNiAxNC4xNzk4NTE5LDkuMTI3NjgwNzYgOS4xMzQ4MjY1Myw5LjEyNzY4MDc2IEM0LjA4OTgwMTE0LDkuMTI3NjgwNzYgMCwxMy4yMTQyODI2IDAsMTguMjU1MzYxNSBMMTguMjY5NjUzMSwxOC4yNTUzNjE1IFoiIGlkPSJPdmFsLTQiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDkuMTM0ODI3LCAxMy42OTE1MjEpIHNjYWxlKC0xLCAtMSkgdHJhbnNsYXRlKC05LjEzNDgyNywgLTEzLjY5MTUyMSkgIj48L3BhdGg+CiAgICAgICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICAgICAgPGcgaWQ9Ikdyb3VwLTE0IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgyMTYuMjk0NzAwLCAxMjMuNzI1NjAwKSByb3RhdGUoLTUuMDAwMDAwKSB0cmFuc2xhdGUoLTIxNi4yOTQ3MDAsIC0xMjMuNzI1NjAwKSB0cmFuc2xhdGUoMTA2LjI5NDcwMCwgMzUuMjI1NjAwKSI+CiAgICAgICAgICAgICAgICAgICAgPGVsbGlwc2UgaWQ9Ik92YWwtMiIgZmlsbD0iI0NGREFFNiIgb3BhY2l0eT0iMC4yNSIgY3g9IjI5LjExNzY0NzEiIGN5PSIyOS4xNDAyNDM5IiByeD0iMjkuMTE3NjQ3MSIgcnk9IjI5LjE0MDI0MzkiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0yIiBmaWxsPSIjQ0ZEQUU2IiBvcGFjaXR5PSIwLjMiIGN4PSIyOS4xMTc2NDcxIiBjeT0iMjkuMTQwMjQzOSIgcng9IjIxLjU2ODYyNzUiIHJ5PSIyMS41ODUzNjU5Ij48L2VsbGlwc2U+CiAgICAgICAgICAgICAgICAgICAgPGVsbGlwc2UgaWQ9Ik92YWwtMi1Db3B5IiBzdHJva2U9IiNDRkRBRTYiIG9wYWNpdHk9IjAuNCIgY3g9IjE3OS4wMTk2MDgiIGN5PSIxMzguMTQ2MzQxIiByeD0iMjMuNzI1NDkwMiIgcnk9IjIzLjc0MzkwMjQiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0yIiBmaWxsPSIjQkFDQUQ5IiBvcGFjaXR5PSIwLjUiIGN4PSIyOS4xMTc2NDcxIiBjeT0iMjkuMTQwMjQzOSIgcng9IjEwLjc4NDMxMzciIHJ5PSIxMC43OTI2ODI5Ij48L2VsbGlwc2U+CiAgICAgICAgICAgICAgICAgICAgPHBhdGggZD0iTTI5LjExNzY0NzEsMzkuOTMyOTI2OCBMMjkuMTE3NjQ3MSwxOC4zNDc1NjEgQzIzLjE2MTYzNTEsMTguMzQ3NTYxIDE4LjMzMzMzMzMsMjMuMTc5NjA5NyAxOC4zMzMzMzMzLDI5LjE0MDI0MzkgQzE4LjMzMzMzMzMsMzUuMTAwODc4MSAyMy4xNjE2MzUxLDM5LjkzMjkyNjggMjkuMTE3NjQ3MSwzOS45MzI5MjY4IFoiIGlkPSJPdmFsLTIiIGZpbGw9IiNCQUNBRDkiPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8ZyBpZD0iR3JvdXAtOSIgb3BhY2l0eT0iMC40NSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTcyLjAwMDAwMCwgMTMxLjAwMDAwMCkiIGZpbGw9IiNFNkExQTYiPgogICAgICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0yLUNvcHktMiIgY3g9IjcuMDE5NjA3ODQiIGN5PSI3LjE0NjM0MTQ2IiByeD0iNi40NzA1ODgyNCIgcnk9IjYuNDc1NjA5NzYiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICAgICAgPHBhdGggZD0iTTAuNTQ5MDE5NjA4LDEzLjYyMTk1MTIgQzQuMTIyNjI2ODEsMTMuNjIxOTUxMiA3LjAxOTYwNzg0LDEwLjcyMjcyMiA3LjAxOTYwNzg0LDcuMTQ2MzQxNDYgQzcuMDE5NjA3ODQsMy41Njk5NjA5NSA0LjEyMjYyNjgxLDAuNjcwNzMxNzA3IDAuNTQ5MDE5NjA4LDAuNjcwNzMxNzA3IEwwLjU0OTAxOTYwOCwxMy42MjE5NTEyIFoiIGlkPSJPdmFsLTItQ29weS0yIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgzLjc4NDMxNCwgNy4xNDYzNDEpIHNjYWxlKC0xLCAxKSB0cmFuc2xhdGUoLTMuNzg0MzE0LCAtNy4xNDYzNDEpICI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgIDwvZz4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0xMCIgZmlsbD0iI0NGREFFNiIgY3g9IjIxOC4zODIzNTMiIGN5PSIxMzguNjg1OTc2IiByeD0iMS42MTc2NDcwNiIgcnk9IjEuNjE4OTAyNDQiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC0xMC1Db3B5LTIiIGZpbGw9IiNFMEI0QjciIG9wYWNpdHk9IjAuMzUiIGN4PSIxNzkuNTU4ODI0IiBjeT0iMTc1LjM4MTA5OCIgcng9IjEuNjE3NjQ3MDYiIHJ5PSIxLjYxODkwMjQ0Ij48L2VsbGlwc2U+CiAgICAgICAgICAgICAgICAgICAgPGVsbGlwc2UgaWQ9Ik92YWwtMTAtQ29weSIgZmlsbD0iI0UwQjRCNyIgb3BhY2l0eT0iMC4zNSIgY3g9IjE4MC4wOTgwMzkiIGN5PSIxMDIuNTMwNDg4IiByeD0iMi4xNTY4NjI3NSIgcnk9IjIuMTU4NTM2NTkiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICA8cGF0aCBkPSJNMjguOTk4NTM4MSwyOS45NjcxNTk4IEwxNzEuMTUxMDE4LDEzMi44NzYwMjQiIGlkPSJQYXRoLTExIiBzdHJva2U9IiNDRkRBRTYiIG9wYWNpdHk9IjAuOCI+PC9wYXRoPgogICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICAgICAgPGcgaWQ9Ikdyb3VwLTEwIiBvcGFjaXR5PSIwLjc5OTk5OTk1MiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTA1NC4xMDA2MzUsIDM2LjY1OTMxNykgcm90YXRlKC0xMS4wMDAwMDApIHRyYW5zbGF0ZSgtMTA1NC4xMDA2MzUsIC0zNi42NTkzMTcpIHRyYW5zbGF0ZSgxMDI2LjYwMDYzNSwgNC42NTkzMTcpIj4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbC03IiBzdHJva2U9IiNDRkRBRTYiIHN0cm9rZS13aWR0aD0iMC45NDExNzY0NzEiIGN4PSI0My44MTM1NTkzIiBjeT0iMzIiIHJ4PSIxMS4xODY0NDA3IiByeT0iMTEuMjk0MTE3NiI+PC9lbGxpcHNlPgogICAgICAgICAgICAgICAgICAgIDxnIGlkPSJHcm91cC0xMiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMzQuNTk2Nzc0LCAyMy4xMTExMTEpIiBmaWxsPSIjQkFDQUQ5Ij4KICAgICAgICAgICAgICAgICAgICAgICAgPGVsbGlwc2UgaWQ9Ik92YWwtNyIgb3BhY2l0eT0iMC40NSIgY3g9IjkuMTg1MzQ3MTgiIGN5PSI4Ljg4ODg4ODg5IiByeD0iOC40NzQ1NzYyNyIgcnk9IjguNTU2MTQ5NzMiPjwvZWxsaXBzZT4KICAgICAgICAgICAgICAgICAgICAgICAgPHBhdGggZD0iTTkuMTg1MzQ3MTgsMTcuNDQ1MDM4NiBDMTMuODY1NzI2NCwxNy40NDUwMzg2IDE3LjY1OTkyMzUsMTMuNjE0MzE5OSAxNy42NTk5MjM1LDguODg4ODg4ODkgQzE3LjY1OTkyMzUsNC4xNjM0NTc4NyAxMy44NjU3MjY0LDAuMzMyNzM5MTU2IDkuMTg1MzQ3MTgsMC4zMzI3MzkxNTYgTDkuMTg1MzQ3MTgsMTcuNDQ1MDM4NiBaIiBpZD0iT3ZhbC03Ij48L3BhdGg+CiAgICAgICAgICAgICAgICAgICAgPC9nPgogICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0zNC42NTk3Mzg1LDI0LjgwOTY5NCBMNS43MTY2NjA4NCw0Ljc2ODc4OTQ1IiBpZD0iUGF0aC0yIiBzdHJva2U9IiNDRkRBRTYiIHN0cm9rZS13aWR0aD0iMC45NDExNzY0NzEiPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8ZWxsaXBzZSBpZD0iT3ZhbCIgc3Ryb2tlPSIjQ0ZEQUU2IiBzdHJva2Utd2lkdGg9IjAuOTQxMTc2NDcxIiBjeD0iMy4yNjI3MTE4NiIgY3k9IjMuMjk0MTE3NjUiIHJ4PSIzLjI2MjcxMTg2IiByeT0iMy4yOTQxMTc2NSI+PC9lbGxpcHNlPgogICAgICAgICAgICAgICAgICAgIDxlbGxpcHNlIGlkPSJPdmFsLUNvcHkiIGZpbGw9IiNGN0UxQUQiIGN4PSIyLjc5NjYxMDE3IiBjeT0iNjEuMTc2NDcwNiIgcng9IjIuNzk2NjEwMTciIHJ5PSIyLjgyMzUyOTQxIj48L2VsbGlwc2U+CiAgICAgICAgICAgICAgICAgICAgPHBhdGggZD0iTTM0LjYzMTI0NDMsMzkuMjkyMjcxMiBMNS4wNjM2NjY2Myw1OS43ODUwODIiIGlkPSJQYXRoLTEwIiBzdHJva2U9IiNDRkRBRTYiIHN0cm9rZS13aWR0aD0iMC45NDExNzY0NzEiPjwvcGF0aD4KICAgICAgICAgICAgICAgIDwvZz4KICAgICAgICAgICAgICAgIDxnIGlkPSJHcm91cC0xOSIgb3BhY2l0eT0iMC4zMyIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTI4Mi41MzcyMTksIDQ0Ni41MDI4NjcpIHJvdGF0ZSgtMTAuMDAwMDAwKSB0cmFuc2xhdGUoLTEyODIuNTM3MjE5LCAtNDQ2LjUwMjg2NykgdHJhbnNsYXRlKDExNDIuNTM3MjE5LCAzMjcuNTAyODY3KSI+CiAgICAgICAgICAgICAgICAgICAgPGcgaWQ9Ikdyb3VwLTE3IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxNDEuMzMzNTM5LCAxMDQuNTAyNzQyKSByb3RhdGUoMjc1LjAwMDAwMCkgdHJhbnNsYXRlKC0xNDEuMzMzNTM5LCAtMTA0LjUwMjc0MikgdHJhbnNsYXRlKDEyOS4zMzM1MzksIDkyLjUwMjc0MikiIGZpbGw9IiNCQUNBRDkiPgogICAgICAgICAgICAgICAgICAgICAgICA8Y2lyY2xlIGlkPSJPdmFsLTQiIG9wYWNpdHk9IjAuNDUiIGN4PSIxMS42NjY2NjY3IiBjeT0iMTEuNjY2NjY2NyIgcj0iMTEuNjY2NjY2NyI+PC9jaXJjbGU+CiAgICAgICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0yMy4zMzMzMzMzLDIzLjMzMzMzMzMgQzIzLjMzMzMzMzMsMTYuODkwMDExMyAxOC4xMDk5ODg3LDExLjY2NjY2NjcgMTEuNjY2NjY2NywxMS42NjY2NjY3IEM1LjIyMzM0NDU5LDExLjY2NjY2NjcgMCwxNi44OTAwMTEzIDAsMjMuMzMzMzMzMyBMMjMuMzMzMzMzMywyMy4zMzMzMzMzIFoiIGlkPSJPdmFsLTQiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExLjY2NjY2NywgMTcuNTAwMDAwKSBzY2FsZSgtMSwgLTEpIHRyYW5zbGF0ZSgtMTEuNjY2NjY3LCAtMTcuNTAwMDAwKSAiPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8L2c+CiAgICAgICAgICAgICAgICAgICAgPGNpcmNsZSBpZD0iT3ZhbC01LUNvcHktNiIgZmlsbD0iI0NGREFFNiIgY3g9IjIwMS44MzMzMzMiIGN5PSI4Ny41IiByPSI1LjgzMzMzMzMzIj48L2NpcmNsZT4KICAgICAgICAgICAgICAgICAgICA8cGF0aCBkPSJNMTQzLjUsODguODEyNjY4NSBMMTU1LjA3MDUwMSwxNy42MDM4NTQ0IiBpZD0iUGF0aC0xNyIgc3Ryb2tlPSIjQkFDQUQ5IiBzdHJva2Utd2lkdGg9IjEuMTY2NjY2NjciPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8cGF0aCBkPSJNMTcuNSwzNy4zMzMzMzMzIEwxMjcuNDY2MjUyLDk3LjY0NDk3MzUiIGlkPSJQYXRoLTE4IiBzdHJva2U9IiNCQUNBRDkiIHN0cm9rZS13aWR0aD0iMS4xNjY2NjY2NyI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgIDxwb2x5bGluZSBpZD0iUGF0aC0xOSIgc3Ryb2tlPSIjQ0ZEQUU2IiBzdHJva2Utd2lkdGg9IjEuMTY2NjY2NjciIHBvaW50cz0iMTQzLjkwMjU5NyAxMjAuMzAyMjgxIDE3NC45MzU0NTUgMjMxLjU3MTM0MiAzOC41IDE0Ny41MTA4NDcgMTI2LjM2Njk0MSAxMTAuODMzMzMzIj48L3BvbHlsaW5lPgogICAgICAgICAgICAgICAgICAgIDxwYXRoIGQ9Ik0xNTkuODMzMzMzLDk5Ljc0NTM4NDIgTDE5NS40MTY2NjcsODkuMjUiIGlkPSJQYXRoLTIwIiBzdHJva2U9IiNFMEI0QjciIHN0cm9rZS13aWR0aD0iMS4xNjY2NjY2NyIgb3BhY2l0eT0iMC42Ij48L3BhdGg+CiAgICAgICAgICAgICAgICAgICAgPHBhdGggZD0iTTIwNS4zMzMzMzMsODIuMTM3MjEwNSBMMjM4LjcxOTQwNiwzNi4xNjY2NjY3IiBpZD0iUGF0aC0yNCIgc3Ryb2tlPSIjQkFDQUQ5IiBzdHJva2Utd2lkdGg9IjEuMTY2NjY2NjciPjwvcGF0aD4KICAgICAgICAgICAgICAgICAgICA8cGF0aCBkPSJNMjY2LjcyMzQyNCwxMzIuMjMxOTg4IEwyMDcuMDgzMzMzLDkwLjQxNjY2NjciIGlkPSJQYXRoLTI1IiBzdHJva2U9IiNDRkRBRTYiIHN0cm9rZS13aWR0aD0iMS4xNjY2NjY2NyI+PC9wYXRoPgogICAgICAgICAgICAgICAgICAgIDxjaXJjbGUgaWQ9Ik92YWwtNSIgZmlsbD0iI0MxRDFFMCIgY3g9IjE1Ni45MTY2NjciIGN5PSI4Ljc1IiByPSI4Ljc1Ij48L2NpcmNsZT4KICAgICAgICAgICAgICAgICAgICA8Y2lyY2xlIGlkPSJPdmFsLTUtQ29weS0zIiBmaWxsPSIjQzFEMUUwIiBjeD0iMzkuMDgzMzMzMyIgY3k9IjE0OC43NSIgcj0iNS4yNSI+PC9jaXJjbGU+CiAgICAgICAgICAgICAgICAgICAgPGNpcmNsZSBpZD0iT3ZhbC01LUNvcHktMiIgZmlsbC1vcGFjaXR5PSIwLjYiIGZpbGw9IiNEMURFRUQiIGN4PSI4Ljc1IiBjeT0iMzMuMjUiIHI9IjguNzUiPjwvY2lyY2xlPgogICAgICAgICAgICAgICAgICAgIDxjaXJjbGUgaWQ9Ik92YWwtNS1Db3B5LTQiIGZpbGwtb3BhY2l0eT0iMC42IiBmaWxsPSIjRDFERUVEIiBjeD0iMjQzLjgzMzMzMyIgY3k9IjMwLjMzMzMzMzMiIHI9IjUuODMzMzMzMzMiPjwvY2lyY2xlPgogICAgICAgICAgICAgICAgICAgIDxjaXJjbGUgaWQ9Ik92YWwtNS1Db3B5LTUiIGZpbGw9IiNFMEI0QjciIGN4PSIxNzUuNTgzMzMzIiBjeT0iMjMyLjc1IiByPSI1LjI1Ij48L2NpcmNsZT4KICAgICAgICAgICAgICAgIDwvZz4KICAgICAgICAgICAgPC9nPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+);
    background-repeat: no-repeat;
    background-position: center right;
    background-size: 100%;
    display: flex;
    align-items: center;
    .login-container {
      border-radius: 10px;
      margin: 0px auto;
      width: 350px;
      padding: 30px 35px 15px 35px;
      background: var(--el-bg-color);
      border: 1px solid #eaeaea;
      text-align: left;
      box-shadow: 0 0 20px 2px rgba(0, 0, 0, 0.1);
    }
    .title {
      margin: 0px auto 40px auto;
      text-align: center;
      color: #505458;
    }
    .remember {
      margin: 0px 0px 35px 0px;
    }
  }
  .market-login{
    width: 1200px;
    margin: 0 auto;
    display: flex;
    border-radius: 8px;
    background: #FFFFFF;
    box-shadow: 0px 0px 12px 0px rgba(0, 0, 0, 0.08);
    .login-container1{
      width: 510px;
      margin-left: 95px;
      .login-img{
        width: 500px;
      }
      .title{
        font-size: 48px;
        font-family: PingFangSC-Medium, PingFang SC;
        font-weight: 500;
        color: #0072FF;
        line-height: 67px;
        letter-spacing: 1px;
        margin: 60px auto 72px;
      }
      .el-form-item{
        margin-bottom: 72px;
        input{
          padding: 0;
          text-indent:0;
          margin-top: 20px;
        }
        .el-form-item__label{
          font-size: 20px;
          font-weight: 400;
          color: rgba(0, 0, 0, 0.56);
          line-height: 28px;
        }
      }
      .el-form-item.is-required:not(.is-no-asterisk)>.el-form-item__label:before{
        content:''
      }
      .el-input__inner{
        border: 0 !important;
        border-bottom: 2px solid rgba(0, 0, 0, 0.16) !important;
        border-radius: 0;
        font-size: 24px;
        font-weight: 500;
        color: rgba(0, 0, 0, 0.84);
      }
      .el-input{
        position: relative;
      }
      .el-input:after{
        position: absolute;
        content: '';
        width:0;
        height: 2px;
        left: 0;
        bottom: 3px;
        z-index: 2;
        transition: all 0.5s;
        background: #0072FF;
      }
      .el-input.hasTxt:after{
        width: 100%;
        .el-input__inner{
          border-right: 0 !important;
        }
      }
      .loadingLg{
        width:100%;
        height: 72px;
        background: #0072FF;
        box-shadow: 0px 5px 15px 0px rgba(0, 114, 255, 0.25);
        border-radius: 4px;
        font-size: 24px;
        font-family: PingFangSC-Medium, PingFang SC;
        font-weight: 500;
        color: #FFFFFF;
      }
    }
  }
  @media screen and (max-width: 1600px) {
    .market-login{
      width: 1050px;
      .login-img {
        width: 350px;
      }

      .login-container1 {
        .el-form-item{
          margin-bottom: 50px;
        }
        .title {
          margin: 40px auto;
        }
      }
    }
  }
  .login-code {
      height: 40px - 2px;
      display: block;
      margin: 0px -20px;
      border-top-right-radius: 2px;
      border-bottom-right-radius: 2px;
    }
</style>