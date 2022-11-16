<template>
    <div class="lyouters">
      <canvas id="lyadmincanvas"></canvas>
      <div class="login-wrap box">
        <el-form label-position="left" :model="ruleForm" :rules="rules" ref="ruleForm" label-width="0px" class="demo-ruleForm login-container">
            <h3 class="title">
                <div class="login-logo">
                   <img style="width: 100%;" src="../assets/logo.png" alt="logo">
               </div>
<!--                <img style="height: 55px;margin-bottom: 10px" src="../assets/logo.png" alt="logo">-->
                <span>用户登录</span>
            </h3>
          <el-form-item prop="username">
            <el-input type="text" size="large" style="font-size: 16px" v-model.trim="ruleForm.username" auto-complete="off" placeholder="账号" maxlength="60">
                  <template #prepend>
                      <el-icon :size="20"><User /></el-icon>
                  </template>
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input type="password" size="large" style="font-size: 16px" v-model.trim="ruleForm.password" auto-complete="off" placeholder="密码" maxlength="60">
                <template #prepend>
                  <el-icon :size="20"><lock /></el-icon>
                </template>
            </el-input>
          </el-form-item>
          <el-form-item prop="captcha">
            <el-input type="text"  size="large" style="font-size: 16px" v-model.trim="ruleForm.captcha" auto-complete="off" @keyup.enter="submitForm('ruleForm')"  placeholder="验证码">
                 <template #prepend>
                    <el-icon :size="20"><circle-check /></el-icon>
                  </template>
                  <template #append>
                    <img class="login-code" :src="image_base" @click="getCaptcha"/>
                  </template>
            </el-input>
          </el-form-item>
          <el-checkbox class="remember" v-model="rememberpassword">记住密码</el-checkbox>
          <el-form-item style="width:100%">
            <el-button type="primary" size="large" :loading="loadingLg" style="width:100%;font-size: 18px" @click="submitForm('ruleForm')">登录</el-button>
          </el-form-item>
        </el-form>
      </div>
       <div class="login-copyright">
           Copyright © 2022 django-vue-lyadmin All rights reserved.
       </div>
    </div>
</template>
<script >
  import {login,apiSystemWebRouter,getCaptcha} from '../api/api'
  import {systemTree} from "@/utils/menuTree.js"
  import {delCookie, getCookie, setCookie} from '../utils/util'
  import {useMutitabsStore} from "../store/mutitabs";

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
        allmenu:[],
        //动画
        WIDTH:"",
        HEIGHT:"",
        POINT :"",
        canvas:null,
        context:null,
        circleArr:[],
        beginX:null,
        beginY:null,
        closeX:null,
        closeY:null,
        moveX:null,
        moveY:null,
        x:null,
        y:null,
        r:null,
        o:null,
      }
    },
      mounted() {
        this.init();
        let that = this
		setInterval(function () {
			for (var i = 0; i < that.POINT; i++) {
				var cir = that.circleArr[i];
				cir.x += cir.moveX;
				cir.y += cir.moveY;
				if (cir.x > that.WIDTH) cir.x = 0;
				else if (cir.x < 0) cir.x = that.WIDTH;
				if (cir.y > that.HEIGHT) cir.y = 0;
				else if (cir.y < 0) cir.y = that.HEIGHT;
			}
			that.draw();
		}, 15);
        window.addEventListener('resize', this.listenResize);
      },
      unmounted() {
          // 页面销毁，去掉监听事件
          window.removeEventListener("resize", this.listenResize);
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
        // 计算搜索栏的高度
        listenResize() {
            this.$nextTick(() => {
                this.init()
            })
        },
        //线条：开始xy坐标，结束xy坐标，线条透明度
         Line (x, y, _x, _y, o) {
            this.beginX = x,
            this.beginY = y,
            this.closeX = _x,
            this.closeY = _y,
            this.o = o;
        },
        //点：圆心xy坐标，半径，每帧移动xy的距离
        Circle (x, y, r, moveX, moveY) {
            this.x = x,
            this.y = y,
            this.r = r,
            this.moveX = moveX,
            this.moveY = moveY;
        },
        //生成max和min之间的随机数
        num (max, _min) {
            var min = arguments[1] || 0;
            return Math.floor(Math.random()*(max-min+1)+min);
        },
        // 绘制原点
         drawCricle (cxt, x, y, r, moveX, moveY) {
            var circle = new this.Circle(x, y, r, moveX, moveY)
            cxt.beginPath()
            cxt.arc(circle.x, circle.y, circle.r, 0, 2*Math.PI)
            cxt.closePath()
            cxt.fill();
            return circle;
        },
        //绘制线条
        drawLine (cxt, x, y, _x, _y, o) {
            var line = new this.Line(x, y, _x, _y, o)
            cxt.beginPath()
            cxt.strokeStyle = 'rgba(0,0,0,'+ o +')'
            cxt.moveTo(line.beginX, line.beginY)
            cxt.lineTo(line.closeX, line.closeY)
            cxt.closePath()
            cxt.stroke();

        },
        //初始化生成原点
        init () {
             //定义画布宽高和生成点的个数
            this.WIDTH = window.innerWidth
            this.HEIGHT = window.innerHeight
            this.POINT = 35;
            this.canvas = document.getElementById('lyadmincanvas');
            this.canvas.width = this.WIDTH-2,
            this.canvas.height = this.HEIGHT-2;
            this.context = this.canvas.getContext('2d');
            this.context.strokeStyle = 'rgba(0,0,0,0.02)',
            this.context.strokeWidth = 1,
            this.context.fillStyle = 'rgba(0,0,0,0.05)';
            this.circleArr = [];
            for (var i = 0; i < this.POINT; i++) {
                this.circleArr.push(this.drawCricle(this.context, this.num(this.WIDTH), this.num(this.HEIGHT), this.num(15, 2), this.num(10, -10)/40, this.num(10, -10)/40));
            }
            this.draw();
        },

	    //每帧绘制
         draw () {
            this.context.clearRect(0,0,this.canvas.width, this.canvas.height);
            for (var i = 0; i < this.POINT; i++) {
                this.drawCricle(this.context, this.circleArr[i].x, this.circleArr[i].y, this.circleArr[i].r);
            }
            for (var i = 0; i < this.POINT; i++) {
                for (var j = 0; j < this.POINT; j++) {
                    if (i + j < this.POINT) {
                        var A = Math.abs(this.circleArr[i+j].x - this.circleArr[i].x),
                            B = Math.abs(this.circleArr[i+j].y - this.circleArr[i].y);
                        var lineLength = Math.sqrt(A*A + B*B);
                        var C = 1/lineLength*7-0.009;
                        var lineOpacity = C > 0.03 ? 0.03 : C;
                        if (lineOpacity > 0) {
                            this.drawLine(this.context, this.circleArr[i].x, this.circleArr[i].y, this.circleArr[i+j].x, this.circleArr[i+j].y, lineOpacity);
                        }
                    }
                }
            }
        },
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
              localStorage.setItem('menuList', JSON.stringify(menuList))
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

            localStorage.setItem('allmenu', JSON.stringify(this.allmenu))
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

<style lang="scss" scoped>
    //django-vue-lyadmin css
    ::v-deep(.el-input__inner){
        &::placeholder{
            font-size: 14px !important;
        }
    }
    ::v-deep(.el-input-group__append){
        background-color: #ffffff !important;
    }
    ::v-deep(.el-input-group__prepend){
        background-color: #ffffff !important;
        .el-icon{
            color: #409eff;
        }
    }
   .lyouters{
        width: 100%;
        height: 100%;
   }
   .login-logo{
        overflow: hidden;
        width: 100px;
        height: 100px;
        border-radius: 50%;
        -webkit-box-shadow: 0 4px 40px rgb(0 0 0 / 7%);
        box-shadow: 0 4px 40px rgb(0 0 0 / 7%);
        background-color: #fff;
        z-index: 10;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
        padding: 20px;
        text-align: center;
        margin-bottom: 20px;
   }
   .login-copyright{
        color: #999;
        width: 100%;
        position: fixed;
        bottom: 30px;
       text-align: center;
   }
  .login-wrap {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    box-sizing: border-box;
    display: flex;
    align-items: center;
    .login-container {
      inset: 2px;
      z-index: 2;
      border-radius: 10px;
      margin: 0px auto;
      width: 374px;
      height: 469px;
      padding: 30px 35px 15px 35px;
      background: var(--el-bg-color);
      border: 1px solid #eaeaea;
      text-align: left;
      box-shadow: 0 0 20px 2px rgba(0, 0, 0, 0.1);
    }
    .title {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        justify-content: center;
        font-size: 19px;
        margin: 0px auto 40px auto;
        color: #409eff;
        font-weight: 700;
    }
    .remember {
      margin: 0px 0px 15px 0px;
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
    .box {
        width: 450px;
        height: 520px;
        background: #ffffff;
        overflow: hidden;
        border-radius: 10px;
    }
    .box::before {
        content: '';
        z-index: 1;
        position: absolute;
        top: -50%;
        left: -50%;
        width: 450px;
        height: 520px;
        transform-origin: bottom right;
        background: linear-gradient(0deg, transparent, #409eff, #409eff);
        animation: animate 10s linear infinite;
    }

    .box::after {
        content: '';
        z-index: 1;
        position: absolute;
        top: -50%;
        left: -50%;
        width: 450px;
        height: 520px;
        transform-origin: bottom right;
        background: linear-gradient(0deg, transparent, #409eff, #409eff);
        animation: animate 10s linear infinite;
        animation-delay: -5s;
    }

    @keyframes animate {
        0% {
            transform: rotate(0deg);
        }

        100% {
            transform: rotate(360deg);
        }
    }
</style>
