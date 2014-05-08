Installation
============

Create user "mlgb"
-------------------
```bash
sudo useradd mlgb
sudo passwd mlgb
su - mlgb
mkdir -p /home/mlgb/.ssh
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
mkdir -p ~/sites/mlgb
cd ~/sites/mlgb
git clone gitlab@source.bodleian.ox.ac.uk:django/buildout.mlgb.git ./
```

Setup server
------------

This will ask you to set a root mysql password. 

```bash
su - <sudo user>
sudo cp /home/mlgb/sites/mlgb/ubuntu_requirements ./
sudo apt-get install $(cat ubuntu_requirements)
```

Install Python
--------------
```bash
mkdir -p ~/Downloads
cd ~/Downloads
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar zxfv Python-2.7.6.tgz
cd Python-2.7.6
mkdir -p ~/python/2.7.6/lib
./configure --prefix=$HOME/python/2.7.6 --enable-shared LDFLAGS="-Wl,-rpath=/home/mlgb/python/2.7.6/lib"
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
eggs-directory = /home/mlgb/.buildout/eggs
download-cache = /home/mlgb/.buildout/downloads
extends-cache = /home/mlgb/.buildout/extends" >> ~/.buildout/default.cfg
```

Create a virtualenv and run the buildout
----------------------------------------
```bash
cd ~/sites/mlgb
~/python/2.7.6/bin/virtualenv ./
. bin/activate
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
cd /home/mlgb/sites/mlgb/parts/solr/
java -Dsolr.solr.home=/home/mlgb/sites/mlgb/parts/solr/solr -jar start.jar
```
Then visit the following two URLs (on the server using lynx?) to instigate a full import for books and catalogues

```bash
http://127.0.1.1:1234/solr/books/dataimport?command=full-import
http://127.0.1.1:1234/solr/catalogues/dataimport?command=full-import
```

Start apache
------------

But first remove the system installation of Apache.

```bash
su - <sudo user>
sudo apt-get purge apache2*
cd /home/mlgb/sites/mlgb/parts/apache/bin/
sudo ./apachectl start
su - mlgb
```
