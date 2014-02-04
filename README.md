Installation
============

Download your key
-----------------
```bash
chmod 700 ~/.ssh/id_rsa
```
Install and configure Git
-------------------------
```bash
sudo apt-get install git
```
```bash
git config --global user.email "my@address.com"
git config --global user.name "name in quotes"
```
Checkout the buildout
---------------------
```bash
mkdir -p ~/sites/django
cd ~/sites/django
git clone gitlab@source.bodleian.ox.ac.uk:django/buildout.mlgb.git ./
```
Setup server
------------

```bash
sudo apt-get install $(cat ubuntu_requirements)
```
This will ask you to set a root mysql password.
Install Python
--------------
```bash
cd ~/Downloads
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar zxfv Python-2.7.6.tgz
cd Python-2.7.6
mkdir -p /home/django/python/2.7.6/lib
./configure --prefix=/home/django/python/2.7.6 --enable-shared LDFLAGS="-Wl,-rpath /home/django/python/2.7.6/lib"
make
make install
cd ~/python/2.7.6/lib/python2.7/config
ln -s ../../libpython2.7.so .
cd ~/Downloads
wget http://python-distribute.org/distribute_setup.py
~/python/2.7.6/bin/python distribute_setup.py
~/python/2.7.6/bin/easy_install pip
~/python/2.7.6/bin/pip install virtualenv
```
Setup the buildout cache
------------------------
```bash
mkdir ~/.buildout
cd ~/.buildout
mkdir eggs
mkdir downloads
mkdir extends
echo "[buildout]
eggs-directory = /home/django/.buildout/eggs
download-cache = /home/django/.buildout/downloads
extends-cache = /home/django/.buildout/extends" >> ~/.buildout/default.cfg
```
Create a virtualenv
-------------------
```bash
cd ~/sites/django
~/python/2.7.6/bin/virtualenv ./
source bin/activate
pip install zc.buildout
pip install distribute
buildout init
```
Run the buildout
----------------
```bash
buildout -c development.cfg
```
Create the database
-------------------
```bash
CREATE DATABASE mlgb;
GRANT ALL PRIVILEGES ON mlgb.* TO "mlgbAdmin"@"localhost" IDENTIFIED BY "<password here>";
FLUSH PRIVILEGES;
EXIT
```
Import a MySQL dump into the database
-------------------------------------
```bash
mysql -u mlgbAdmin -p -h localhost mlgb < mlgb_db_dump.sql 
```
Start Apache
------------
```bash
sudo ~/sites/django/parts/apache/bin/apachectl start
```