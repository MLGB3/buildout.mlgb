Installation
============

Please note that MLGB currently only works on Ubuntu 12.0 with Python 2.7.3.

All re-indexing scripts (```/parts/jobs``` and ```/parts/index```) need linking to the MySQLdb egg either via an entry point or buildout templating - 9.1.15 CTB

Create user "mlgb"
------------------
```bash
sudo adduser mlgb
```
```bash
su - mlgb
mkdir -p /home/mlgb/.ssh
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
mkdir -p ~/sites/mlgb
cd ~/sites/mlgb
git clone gitlab@source.bodleian.ox.ac.uk:mlgb/buildout.mlgb.git ./
```

Setup server
------------

This will ask you to set a root mysql password.

```bash
cd ~/sites/mlgb
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
./configure --prefix=$HOME/python/2.7.3 --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath=/home/mlgb/python/2.7.3/lib"
make
make install
cd ~/python/2.7.3/lib/python2.7/config
ln -s ../../libpython2.7.so .
cd ~/Downloads
wget https://pypi.python.org/packages/source/d/distribute/distribute-0.7.3.zip
unzip distribute-0.7.3.zip
cd distribute-0.7.3
~/python/2.7.3/bin/python setup.py install
~/python/2.7.3/bin/python distribute_setup.py
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
eggs-directory = /home/mlgb/.buildout/eggs
download-cache = /home/mlgb/.buildout/downloads
extends-cache = /home/mlgb/.buildout/extends" >> ~/.buildout/default.cfg
```

Create a virtualenv and run the buildout
----------------------------------------

```bash
cd ~/sites/mlgb
~/python/2.7.3/bin/virtualenv ./
. bin/activate
pip install zc.buildout
pip install distribute
buildout init
buildout -c development.cfg
```

Setup the reboot script in the sudo crontab
-------------------------------------------

```bash
su - <sudo user>
sudo crontab $HOME/sites/mlgb/bin/cron.txt
su - mlgb
```

Create the database
-------------------

mysql root password as given during installation.

```bash
mysql --user=root --password=<password here>
```

Please see mlgbAdmin password in settings.py

```bash
CREATE DATABASE mlgb;
GRANT ALL PRIVILEGES ON mlgb.* TO "mlgbAdmin"@"localhost" IDENTIFIED BY "mlgb";
FLUSH PRIVILEGES;
EXIT
```

Import a MySQL dump into the database

```bash
mysql -u mlgbAdmin -p -h localhost mlgb < mlgb-database-dump.sql
```


Startup script
--------------

Run the start script:

```bash
/home/mlgb/sites/mlgb/parts/jobs/mlgbctl start 
```

Other options for mlgbctl are stop and startnoindex (the latter starts solr and apache only without running the reindex scripts).


Port 8080
---------

Please note: to run under 8080 on a development server you will need to request the port via infrastructure services and enter the following command on your server:

```bash
ufw allow 8080/tcp
```

In the case of a development machine (if you've run development.cfg) you should now be able to browse to mlgb3-dev2.bodleian.ox.ac.uk:8080.

If you're running a production machine you should be able to browse mlgb3-dev2.bodleian.ox.ac.uk.

Database connection
-------------------

For production, in mlgb.indexer.connection update the database username and password

