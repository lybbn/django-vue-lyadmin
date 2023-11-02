from mysystem.models import Users
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.core.management.base import BaseCommand

class LyadminGenerateTokenSerializer(TokenObtainPairSerializer):
    """
    token序列化器:
    重写djangorestframework-simplejwt的序列化器
    """

    @classmethod
    def get_token(cls, user):
        refresh = super(LyadminGenerateTokenSerializer,cls).get_token(user)
        data = {}
        data['identity'] = user.identity
        data['userId'] = user.id
        data['refresh'] = str(refresh)
        data['access'] = str(refresh.access_token)
        return data

class Command(BaseCommand):
    """
    快速生成用户jwt token:
    python manage.py generate_token 用户ID
    """

    def add_arguments(self, parser):
        parser.add_argument('userid', nargs='*', type=str, )

    def handle(self, *args, **options):
        userid_list = options.get('userid')
        if userid_list:
            userid = userid_list[0]
            user = Users.objects.filter(id=userid).first()
            if not user:
                print("用户不存在")
                return
            userinfo = LyadminGenerateTokenSerializer.get_token(user)
            print(userinfo)
        else:
            print(f"请输入要生成token的用户ID如：python manage.py generate_token 用户ID")
