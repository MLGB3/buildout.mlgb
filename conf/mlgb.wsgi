import os, sys

os.environ['PYTHON_EGG_CACHE'] = '/tmp'

sys.path.append('/home/xiaofeng/.buildout/eggs/Django-1.2-py2.7.egg/')
sys.path.append('/home/xiaofeng/sites/bdlss/')
sys.path.append('/home/xiaofeng/sites/')
os.environ['DJANGO_SETTINGS_MODULE'] = 'mysite.apache.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
