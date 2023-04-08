<template>
    <el-tabs v-model="activeName" @tab-click="handleClick" tab-position="left">
      <el-tab-pane label="用户设置" name="userInfo" >
          <el-form ref="userInfoForm" :model="userInfo" :disabled="!isShowBtn('personalCenter','个人中心','Update')"  required-asterisk :rules="userInforules" :label-position="position" center label-width="120px" style="margin: 50px auto">
            <el-form-item prop="name" required label="姓名:">
              <el-input size="large" v-model="userInfo.name" clearable style="width: 360px" ></el-input>
            </el-form-item>
            <el-form-item label="电话号码:" prop="mobile">
              <el-input size="large" v-model="userInfo.mobile" clearable style="width: 360px" ></el-input>
            </el-form-item>
            <el-form-item label="邮箱:" prop="email">
              <el-input size="large" v-model="userInfo.email" clearable style="width: 360px" ></el-input>
            </el-form-item>
            <el-form-item label="性別:" prop="gender">
              <el-radio-group v-model="userInfo.gender">
                <el-radio :label="1">男</el-radio>
                <el-radio :label="0">女</el-radio>
                <el-radio :label="-1">未知</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item>
              <el-button @click="updateInfo" type="primary" v-show="isShowBtn('personalCenter','个人中心','Update')">
                <i class="fa fa-check"></i>
                更新
              </el-button>
              <el-button @click="resetForm('info')" type="info" v-show="isShowBtn('personalCenter','个人中心','Update')">
                <i class="fa fa-reply-all"></i>
                重置
              </el-button>
            </el-form-item>
          </el-form>
      </el-tab-pane>
      <el-tab-pane label="密码设置" name="passwrod"  >
          <el-form ref="userPasswordForm" :model="userPasswordInfo" required-asterisk :label-position="position" :rules="passwordRules" center  label-width="120px" style="margin: 50px auto">
            <el-form-item label="原密码：" required prop="oldPassword">
              <el-input size="large" v-model="userPasswordInfo.oldPassword" clearable style="width: 360px"></el-input>
            </el-form-item>
            <el-form-item required prop="newPassword" label="新密码：">
              <el-input size="large" type="password" v-model="userPasswordInfo.newPassword" clearable style="width: 360px"></el-input>
            </el-form-item>
            <el-form-item required prop="newPassword2" label="确认密码：">
              <el-input size="large" type="password" v-model="userPasswordInfo.newPassword2" clearable style="width: 360px"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button  type="primary" @click="settingPassword" v-show="isShowBtn('personalCenter','个人中心','Changepassword')">
                <i class="fa fa-check"></i>提交
              </el-button>
              <el-button @click="resetForm('passwordForm')" type="info" v-show="isShowBtn('personalCenter','个人中心','Changepassword')">
                <i class="fa fa-reply-all"></i>重置
              </el-button>
            </el-form-item>
          </el-form>
      </el-tab-pane>
    </el-tabs>
</template>

<script>
    import {systemUserUserInfoEdit,systemUserUserInfo,systemUserChangePassword} from '@/api/api'
    import {useMutitabsStore} from "@/store/mutitabs";
    export default {
        name: "personalCenter",
        setup(){
            const mutitabsstore = useMutitabsStore()
            return { mutitabsstore}
        },
        data() {
            var validatePass = (rule, value, callback) => {
              const pwdRegex = new RegExp('(?=.*[0-9])(?=.*[a-zA-Z]).{8,30}')
              if (value === '') {
                callback(new Error('请输入密码'))
              } else if (value === this.userPasswordInfo.oldPassword) {
                callback(new Error('原密码与新密码一致'))
              } else if (!pwdRegex.test(value)) {
                callback(new Error('您的密码复杂度太低(密码中必须包含字母、数字)'))
              } else {
                if (this.userPasswordInfo.newPassword2 !== '') {
                  this.$refs.userPasswordForm.validateField('newPassword2')
                }
                callback()
              }
            }
            var validatePass2 = (rule, value, callback) => {
              if (value === '') {
                callback(new Error('请再次输入密码'))
              } else if (value !== this.userPasswordInfo.newPassword) {
                callback(new Error('两次输入密码不一致!'))
              } else {
                callback()
              }
            }
            return{
                position: 'right',
              activeName: 'userInfo',
              userInfo: {
                name: '',
                gender: 1,
                mobile: '',
                avatar: '',
                email: ''
              },
              userInforules: {
                name: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
                mobile: [
                  { pattern: /^1[3|4|5|7|8]\d{9}$/, message: '请输入正确手机号' }
                ]
              },
              userPasswordInfo: {
                oldPassword: '',
                newPassword: '',
                newPassword2: ''
              },
              passwordRules: {
                oldPassword: [
                  {
                    required: true,
                    message: '请输入原密码',
                    trigger: 'blur'
                  }
                ],
                newPassword: [{ validator: validatePass, trigger: 'blur' }],
                newPassword2: [{ validator: validatePass2, trigger: 'blur' }]
              }
            }
        },
        mounted () {
        this.getCurrentUserInfo()
        },
        methods:{
            /**
             * 获取当前用户信息
             */
            getCurrentUserInfo () {
                systemUserUserInfo().then(res=>{
                    if(res.code == 2000) {
                        this.userInfo=res.data.data
                    }

                })
            },
            /**
             * 更新用户信息
             */
            updateInfo () {
              const _self = this

              _self.$refs.userInfoForm.validate((valid) => {
                if (valid) {
                    //console.log(_self.userInfo)
                    systemUserUserInfoEdit(_self.userInfo).then(res=>{
                            if(res.code ==2000) {
                                this.$message.success(res.msg)
                                _self.getCurrentUserInfo()
                            } else {
                                this.$message.warning(res.msg)
                            }
                        })
                } else {
                  // 校验失败
                  // 登录表单校验失败
                  this.$message.error('表单校验失败，请检查')
                }
              })
            },
            // 重置
            resetForm (name) {
              const _self = this
              if (name === 'info') {
                _self.getCurrentUserInfo()
              } else {
                _self.userPasswordInfo = {
                  oldPassword: '',
                  newPassword: '',
                  newPassword2: ''
                }
              }
            },
            // tab切换,默认切换清除原字符
            handleClick (tab, event) {
              const _self = this
              // if (tab.paneName === 'userInfo') {
              //   _self.$refs.userPasswordForm.resetFields()
              // } else {
              //   _self.$refs.userInfoForm.resetFields()
              // }
            },
            /**
             * 重新设置密码
             */
            settingPassword () {
              const _self = this

              _self.$refs.userPasswordForm.validate((valid) => {
                if (valid) {
                  const userId = this.mutitabsstore.getUserId
                  if (userId) {
                    const params = JSON.parse(JSON.stringify(_self.userPasswordInfo))
                      params.id = userId
                    systemUserChangePassword(params).then(res=>{
                            if(res.code ==2000) {
                                _self.activeName = 'userInfo'
                                this.$message.success(res.msg)
                            } else {
                                this.$message.warning(res.msg)
                            }
                        })
                  }
                } else {
                  // 校验失败
                  // 登录表单校验失败
                  this.$message.error('表单校验失败，请检查')
                    }
                  })
                }

        }
    }
</script>

<style scoped>
  .el-tabs .el-tabs__content{
    background-color: var(--el-bg-color) !important;
  }
  .el-tabs{
    background-color: var(--el-bg-color) !important;
  }
  ::v-deep(.el-tabs__header){
    margin-top: 20px !important;
  }
</style>
