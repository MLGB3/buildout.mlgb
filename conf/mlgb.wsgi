import os, sys

os.environ['PYTHON_EGG_CACHE'] = '/tmp'

sys.path.append('/home/django/.buildout/eggs/Django-1.2-py2.7.egg/')
sys.path.append('/home/django/sites/django/')

os.environ['DJANGO_SETTINGS_MODULE'] = 'mysite.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()