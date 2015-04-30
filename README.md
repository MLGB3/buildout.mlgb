Introduction
============

The buildout relies on the following git repositories auto-checkedout by mr.developer in the buildout:

```bash
mlgb.cron = git gitlab@source.bodleian.ox.ac.uk:mlgb/mlgb.cron.git egg=false
mlgb.indexer = git gitlab@source.bodleian.ox.ac.uk:mlgb/mlgb.indexer.git
mysite = git gitlab@source.bodleian.ox.ac.uk:mlgb/mysite.git path=${buildout:directory}
# media and templates dir 
static = git gitlab@source.bodleian.ox.ac.uk:mlgb/mlgb.static.git egg=false path=${buildout:directory}
# solr conf
solr = git gitlab@source.bodleian.ox.ac.uk:mlgb/solr.git egg=false path=${buildout:directory}
```

The ```mlgb.cron``` repository consists of nightly run cron jobs.
The ```mlgb.indexer``` repository consists of indexing scripts.
The ```mysite``` repository consists of the MLGB3 codebase.
The ```static``` repository consists of static media files such as images and templates.
The ```solr``` repository consists of schema XML for the ```books``` and ```catalogue``` Solr cores. This is rsync'ed to the solr home directory after checking out.

Installation
============

Please note that MLGB currently only works on Ubuntu 12.0 with Python 2.7.3 and Solr 1.3.0. Other versions can be found in ```versions.cfg```.

All re-indexing scripts (```/parts/jobs``` and ```/parts/index```) need linking to the MySQLdb egg either via an entry point or buildout templating - 9.1.15 CTB

Create user "bodl-mlgb-svc"
------------------
```bash
sudo useradd bodl-mlgb-svc
sudo passwd bodl-mlgb-svc
sudo mkdir -p /home/bodl-mlgb-svc/.ssh
cd /home
sudo chown -R bodl-mlgb-svc:bodl-mlgb-svc bodl-mlgb-svc/
sudo chsh -s /bin/bash bodl-mlgb-svc
su - bodl-mlgb-svc
ssh-keygen -t rsa
```
Copy and paste your key into gitlab by choosing My Profile (the grey person graphic link in the top right hand corner) then Add Public Key.

```bash
cat ~/.ssh/id_rsa.pub
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
mkdir -p ~/sites/bodl-mlgb-svc
cd ~/sites/bodl-mlgb-svc
git clone gitlab@source.bodleian.ox.ac.uk:mlgb/buildout.mlgb.git ./
```

Setup server
------------

This will ask you to set a root mysql password.

```bash
cd ~/sites/bodl-mlgb-svc
sudo apt-get install $(cat ubuntu_requirements)
```

Install Python
--------------

```bash
mkdir -p ~/Downloads
cd ~/Downloads
wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar zxfv Python-2.7.3.tgz
cd Python-2.7.3
./configure --prefix=$HOME/python/2.7.3 --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath=/home/bodl-mlgb-svc/python/2.7.3/lib"
make
make install
cd ~/python/2.7.3/lib/python2.7/config
ln -s ../../libpython2.7.so .
cd ~/Downloads
wget https://pypi.python.org/packages/source/d/distribute/distribute-0.7.3.zip
unzip distribute-0.7.3.zip
cd distribute-0.7.3
~/python/2.7.3/bin/python setup.py install
~/python/2.7.3/bin/easy_install pip
~/python/2.7.3/bin/pip install virtualenv
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
eggs-directory = /home/bodl-mlgb-svc/.buildout/eggs
download-cache = /home/bodl-mlgb-svc/.buildout/downloads
extends-cache = /home/bodl-mlgb-svc/.buildout/extends" > ~/.buildout/default.cfg
```

Create a virtualenv and run the buildout
----------------------------------------

```bash
cd ~/sites/bodl-mlgb-svc
~/python/2.7.3/bin/virtualenv ./
. bin/activate
pip install zc.buildout
pip install distribute
buildout init
buildout -c development.cfg
```

Setup the reboot script in the sudo crontab
-------------------------------------------

Setup the re-indexing cron jobs (for app user) and reboot script (for sudo):

```bash
su - <sudo user>
sudo crontab /home/bodl-mlgb-svc/sites/bodl-mlgb-svc/parts/jobs/cron.txt
sudo su - bodl-mlgb-svc
crontab /home/bodl-mlgb-svc/sites/bodl-mlgb-svc/parts/jobs/crondump.txt
```
Create the database
-------------------

mysql root password as given during installation.

```bash
mysql -uroot -p
```

Please see mlgbAdmin password in settings.py

```bash
CREATE DATABASE mlgb;
GRANT ALL PRIVILEGES ON mlgb.* TO "mlgbAdmin"@"localhost" IDENTIFIED BY "<password here>";
FLUSH PRIVILEGES;
EXIT
```

Import a MySQL dump into the database

```bash
cd ~/sites/bodl-mlgb-svc
mysql -u mlgbAdmin -p -h localhost mlgb < mlgb-database-dump.sql 
```


Startup script
--------------

Run the start script (for development):

```bash
/home/bodl-mlgb-svc/sites/bodl-mlgb-svc/bin/mlgbctl start 
```

Or sudo run the start script if you're on production and port 80:

```bash
su - <sudo user>
sudo /home/bodl-mlgb-svc/sites/bodl-mlgb-svc/bin/mlgbctl start 
```

Other options for mlgbctl are ```stop``` and ```startnoindex``` (the latter starts solr and apache only without running the reindex scripts).


Port 8080
---------

Please note: to run under 8080 on a development server you will need to request the port via infrastructure services and enter the following command on your server:

```bash
su - <sudo user>
sudo ufw allow 8080/tcp
```

In the case of a development machine (if you've run development.cfg) you should now be able to browse to <your url>:8080.

If you're running a production machine you should be able to browse <your url>.

