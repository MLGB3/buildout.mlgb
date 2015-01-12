# Django settings for mysite project.

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

DATABASE_ENGINE = 'mysql'
DATABASE_NAME = 'mlgb'
DATABASE_USER = '${users:mysql_user}'
DATABASE_PASSWORD = '${passwords:mysql_user}'
DATABASE_HOST = ''  # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''  # Set to empty string for default. Not used with sqlite3.

TIME_ZONE = 'Europe/London'

LANGUAGE_CODE = 'en-us'

SITE_ID = 1

USE_I18N = True

MEDIA_ROOT = '${buildout:directory}/static/media/'

MEDIA_URL = '/books/media/'

ADMIN_MEDIA_PREFIX = '/media/'


SECRET_KEY = 'zv&ymi5k&u!eya$bay_bbqb6k*1k-y3h+^28y*d!z*_m7+*x4y'


TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.redirects.middleware.RedirectFallbackMiddleware',
)

ROOT_URLCONF = 'mysite.apache.urls'

TEMPLATE_DIRS = (
    "${buildout:directory}/static/templates/"
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.redirects',
    'django.contrib.sites',
    'django.contrib.admin',
    'mysite.books',
    'mysite.mlgb',
    
)
