import os, sys

os.environ['PYTHON_EGG_CACHE'] = '/tmp'
sys.path.append('${buildout:directory}/src')

os.environ['DJANGO_SETTINGS_MODULE'] = 'mysite.apache.settings'
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()