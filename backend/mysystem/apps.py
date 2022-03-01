from django.apps import AppConfig


class MysystemConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'mysystem'

    # 激活signals信号
    def ready(self):
        import mysystem.signals
