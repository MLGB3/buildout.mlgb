
Installation
============

Create user "mlgb"
------------------

```bash
sudo useradd mlgb
sudo passwd mlgb
su - mlgb
mkdir -p /home/mlgb/.ssh
ssh-keygen -t rsa
```

Copy and paste your key into gitlab by choosing settings | add SSH key.

```bash
cat ~/.ssh/id_rsa
```

Install and configure Git
-------------------------

```bash
sudo apt-get install git
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

```bash
mysql -u mlgbAdmin -p -h localhost mlgb < mlgb_db_dump.sql 
```

Start apache
------------

Remove the system installation of Apache, then start our user instance of apache.

```bash
su - <sudo user>
sudo apt-get purge apache2*
cd /home/mlgb/sites/mlgb/parts/apache/bin/
sudo ./apachectl start
su - mlgb
```

Start Solr
----------

```bash
cd /home/mlgb/sites/mlgb/parts/solr/
java -Dsolr.solr.home=/home/mlgb/sites/mlgb/parts/solr/solr -jar start.jar
```

Then run the cron jobs (these will run around midnight every night, you can check they've been set via "crontab -e"). When running this for the purposes of installation you must ensure you deactivate your virtualenv.

```bash
deactivate
export MLGBADMINPW=blessing; /home/mlgb/sites/mlgb/parts/jobs/reindex.sh > /home/mlgb/sites/mlgb/parts/jobs/reindex.log 2>&1
```






