#!/bin/bash
source ~/.bashrc
# python3 manage.py makemigrations
# python3 manage.py migrate
# python3 manage.py init -y
daphne -b 0.0.0.0 -p 8000 --proxy-headers application.asgi:application