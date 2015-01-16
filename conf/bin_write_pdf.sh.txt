#! /bin/bash
# This needs to be run by root, as wkhtmltopdf doesn't seem to work otherwise

echo 'Writing PDF...'

cd /home/mlgb/sites/mlgb/parts/jobs
python write_static_mlgb.py

cd /home/mlgb/sites/mlgb/static/media/pdf

/home/mlgb/sites/mlgb/parts/jobs/wkhtmltopdf.sh --encoding utf8 mlgb3.html mlgb3.pdf

chown mlgb mlgb3.*
chgrp mlgb mlgb3.*
