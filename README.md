Installation
============

Create user "bdlss"
-------------------
```bash
sudo useradd bdlss
sudo passwd bdlss
su - bdlss
mkdir -p /home/bdlss/.ssh
ssh-keygen -t rsa
```

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
mkdir -p ~/sites/bdlss
cd ~/sites/bdlss
git clone gitlab@source.bodleian.ox.ac.uk:django/buildout.mlgb.git ./
```

Setup server
------------

```bash
su - <sudo user>
sudo cp /home/bdlss/sites/bdlss/ubuntu_requirements ./
sudo apt-get install $(cat ubuntu_requirements)
su - bdlss
```
This will ask you to set a root mysql password.

Install Python
--------------
```bash
mkdir -p ~/Downloads
cd ~/Downloads
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar zxfv Python-2.7.6.tgz
cd Python-2.7.6
mkdir -p /home/bdlss/python/2.7.6/lib
./configure --prefix=/home/bdlss/python/2.7.6 --enable-shared LDFLAGS="-Wl,-rpath /home/bdlss/python/2.7.6/lib"
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
eggs-directory = /home/bdlss/.buildout/eggs
download-cache = /home/bdlss/.buildout/downloads
extends-cache = /home/bdlss/.buildout/extends" >> ~/.buildout/default.cfg
```
Create a virtualenv and run the buildout
----------------------------------------
```bash
cd ~/sites/bdlss
~/python/2.7.6/bin/virtualenv ./
source bin/activate
pip install zc.buildout
pip install distribute
buildout init
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
Start Solr
----------
```bash
cd ~/sites/bdlss/parts/solr/
java -Dsolr.solr.=/home/bdlss/sites/bdlss/parts/solr/solr -jar start.jar
```
Then visit the following two URLs to instigate a full import for books and catalogues

```bash
http://0.0.0.0:1234/solr/books/dataimport?command=full-import
http://0.0.0.0:1234/solr/catalogues/dataimport?command=full-import
```
Edit VirtualHost file
---------------------
At /etc/apache2/sites-available/ edit the 'default' file and place the following line in as below

```bash
<VirtualHost *:80>
    ...
    WSGIScriptAlias / "/home/bdlss/sites/bdlss/mysite/apache/mlgb.wsgi"
```
Start Apache
------------

```bash
cd ~/sites/bdlss/parts/apache/bin
sudo apachectl start
```
