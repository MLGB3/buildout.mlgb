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
Install Python
--------------
```bash
cd ~/Downloads
wget http://www.python.org/ftp/python/2.6.5/Python-2.6.5.tgz
tar zxfv Python-2.6.5.tgz
cd Python-2.6.5
./configure --prefix=/home/django/python/2.6.5
make
make install
cd ..
wget http://python-distribute.org/distribute_setup.py
~/python/2.6.5/bin/python distribute_setup.py
~/python/2.6.5/bin/easy_install pip
~/python/2.6.5/bin/pip install virtualenv
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
eggs-directory = /home/wordpress/.buildout/eggs
download-cache = /home/wordpress/.buildout/downloads
extends-cache = /home/wordpress/.buildout/extends" >> ~/.buildout/default.cfg
```
Create a virtualenv
-------------------
```bash
cd ~/sites/wordpress
~/python/2.6.5/bin/virtualenv ./
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
