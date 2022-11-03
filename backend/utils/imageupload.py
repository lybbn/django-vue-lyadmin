# -*- coding: utf-8 -*-

"""
@Remark: 自定义图片上传
"""
import os
import datetime
from django.conf import settings
from utils.common import renameuploadimg,getfulldomian
from config import DOMAIN_HOST

def ImageUpload(request,dirs):
    """
    request:请求
    dirs:要上传到那个目录
    """
    image = request.data.getlist('file')
    msg = {}
    if not image:
        msg['code'] = 400
        msg['msg'] = "上传的图片不能为空"
        return msg

    notimg_file = []
    img_file = []
    try:
        # 多图片上传，也可单图片
        for img in image:
            img_name = img.name
            # 图片类型content-type检查
            if not img.content_type.startswith('image/') and not img.content_type.startswith('video/') and not img.content_type.startswith('audio/'):
                msg['code'] = 400
                msg['msg'] = "请上传正确的文件格式"
                return msg

            if not img_name.endswith(
                    ('.jpg', '.jpeg', '.png', 'gif', '.bmp', '.JPG', '.JPEG', '.PNG', 'GIF', '.BMP', '.mp4','.flv')):
                notimg_file.append(img_name)

            if img.size > 1024 * 500000:
                msg['code'] = 400
                msg['msg'] = "图片大小不能超过500M"
                return msg

            else:
                curr_time = datetime.datetime.now()
                image_name = renameuploadimg(img_name)
                time_path = curr_time.strftime("%Y-%m-%d")
                img_task_dir = dirs #对应models中的上传路径
                sub_path = os.path.join(settings.MEDIA_ROOT, img_task_dir, time_path)
                if not os.path.exists(sub_path):
                    os.makedirs(sub_path)
                image_path = os.path.join(sub_path, image_name)
                # web_img_url = settings.MEDIA_URL + img_task_dir + "/" + time_path + "/" + image_name#相对路径/media/xxx/xxxx/xxx.png
                web_img_url =  DOMAIN_HOST+settings.MEDIA_URL + img_task_dir + "/" + time_path + "/" + image_name  # 绝对路径http://xxx.xxx.com/media/xxx/xxxx/xxx.png
                f = open(image_path, 'wb')
                for i in img.chunks():
                    f.write(i)
                f.close()
                img_file.append(web_img_url)

        if notimg_file:
            msg['code'] = 400
            msg['msg'] = '请检查是否支持的文件，失败文件部分如下：{0}'.format(','.join(notimg_file[:10]))
            return msg

        msg['code'] = 200
        msg['img'] = img_file#['/media/xxx/xxx/xxx.png']
        msg['msg'] = '上传成功'
        return msg

    except Exception as e:
        msg['code'] = 400
        msg['msg'] = '上传失败'
        return msg

def ImageUpload2(request,paramsname,dirs):
    """
    根据指定的名称参数名获取上传的文件
    request:请求
    paramsname:为formData中提交数据的名称
    dirs:要上传到那个目录
    """
    image = request.data.getlist(paramsname)
    msg = {}
    if not image:
        msg['code'] = 400
        msg['msg'] = "上传的图片不能为空"
        return msg

    notimg_file = []
    img_file = []
    try:
        # 多图片上传，也可单图片
        for img in image:
            img_name = img.name
            # 图片类型content-type检查
            if not img.content_type.startswith('image/'):
                msg['code'] = 400
                msg['msg'] = "请上传正确的图片格式"
                return msg

            if not img_name.endswith(
                    ('.jpg', '.jpeg', '.png', 'gif', '.bmp', '.JPG', '.JPEG', '.PNG', 'GIF', '.BMP')):
                notimg_file.append(img_name)

            if img.size > 1024 * 50000:
                msg['code'] = 400
                msg['msg'] = "图片大小不能超过50M"
                return msg

            else:
                curr_time = datetime.datetime.now()
                image_name = renameuploadimg(img_name)
                time_path = curr_time.strftime("%Y-%m-%d")
                img_task_dir = dirs #对应models中的上传路径
                sub_path = os.path.join(settings.MEDIA_ROOT, img_task_dir, time_path)
                if not os.path.exists(sub_path):
                    os.makedirs(sub_path)
                image_path = os.path.join(sub_path, image_name)
                # web_img_url = settings.MEDIA_URL + img_task_dir + "/" + time_path + "/" + image_name#相对路径/media/xxx/xxxx/xxx.png
                web_img_url =  DOMAIN_HOST+settings.MEDIA_URL + img_task_dir + "/" + time_path + "/" + image_name  # 绝对路径http://xxx.xxx.com/media/xxx/xxxx/xxx.png
                f = open(image_path, 'wb')
                for i in img.chunks():
                    f.write(i)
                f.close()
                img_file.append(web_img_url)

        if notimg_file:
            msg['code'] = 400
            msg['msg'] = '请检查是否支持的图片，失败文件部分如下：{0}'.format(','.join(notimg_file[:10]))
            return msg

        msg['code'] = 200
        msg['img'] = img_file#['/media/xxx/xxx/xxx.png']
        msg['msg'] = '上传成功'
        return msg

    except Exception as e:
        msg['code'] = 400
        msg['msg'] = '图片上传失败'
        return msg