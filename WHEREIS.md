MLGB
----

MLGB runs inside a virtualenv within the /home/mlgb/sites/mlgb/ directory. It can be activated and deactivated from within the directory as follows:

```bash
. bin/activate
deactivate
```

Everything within the virtualenv, including Apache, runs under the application user, **mlgb**. Sudo rights are available to the developer logged into the machine and it may be necessary to switch from time to time. However, ensure any files produced as sudo/your own login are chowned as mlgb, the application user.

This document describes where the following aspects of the application stack are located
- **Buildout**, resultant files on server after running buildout
- **Application**, framework and services relied upon
- **Run scripts**, i.e. CLI scripts often to be run as cronjobs
- **Log files**
- **Cron jobs**, i.e. cron settings

Buildout
--------

The buildout scripts are located as follows. Except *.installed.cfg* and *.mr.developer.cfg* this is your buildout as downloaded from the buildout repository. In the **home/mlgb/sites/mlgb/** directory we have the following:

```bash
buildouts/
conf/
bootstrap.py
buildout.cfg
development.cfg
production.cfg
ubuntu_requirements
versions.cfg
.installed.cfg
.mr.developer.cfg
```
*.installed.cfg* will give you a useful breakdown of everything that happened during the last buildout execution.

In /home/mlgb/.buildout we have the buildout cache (as created by running the buildout), comprising:

```bash
downloads/
eggs/
extends/
default.cfg
```

Application
-----------

Everything exists under **/home/mlgb/**. The virtualenv python install is in **/home/mlgb/python/** (this python is specific to the application and different to the system one). The application itself resides at **/home/mlgb/sites/mlgb/**.

#### **Django**

The Django controller scripts are located in **/home/mlgb/sites/mlgb/bin/**

The Django eggs are located in the buildout cache at **/home/mlgb/.buildout/eggs/Django-1.2-py2.7.egg/** (this is appended to the syspath in /home/mlgb/sites/mlgb/mysite/apache/mlgb.wsgi)

The codebase is located in **/home/mlgb/sites/mlgb/mysite/**

Django settings.py and all apache WSGI settings are in **/home/mlgb/sites/mlgb/mysite/apache/**

A list of all installed Django eggs can be found via the Omelette directory in **parts/omelette/**.

#### **Solr, Jetty, Apache, MySQL**

Solr and Apache are in the parts directory located at **/home/mlgb/sites/mlgb/parts/** under their respective names.

Solr runs on **127.0.1.1:1234** and can be accessed on the server via lynx. *IP/port can be changed in development/production.cfg.*

Jetty is packaged with solr in the **parts/solr/solr** directory.

MySQL is system installed and runs on **localhost:3306**. It can be accessed via the mysql CLI. *IP/port can be changed in development/production.cfg.*

Supervisor runs on **127.0.2.1:3306**. *IP/port can be changed in development/production.cfg.*

#### **Media**

The static media is located in **/home/mlgb/sites/mlgb/static/**

The admin media is currently located at **/home/mlgb/.buildout/eggs/Django-1.2-py2.7.egg/django/contrib/admin/media/** though this may change

Run scripts
-----------

These are all located in **/home/mlgb/sites/mlgb/parts/jobs**.

#### **reindex.sh** 

This will run the reindexing process that is scheduled via cron. Log files will be deposited in *parts/jobs*, data files will be created in *parts/index*

#### **mlgbctl start | restart | stop | startnoindex**

Start, restart and stop will control solr, apache and (in the case of start) run the reindex.sh script (see above).

The action startnoindex will start solr and apache only.

Log files
---------

Solr log files are in **parts/solr/logs/**

Apache log files are in **parts/apache/logs/**

Re-indexing log files are in **parts/jobs/**

In the event of a reboot there is a *reboot.log* in **parts/jobs/**

Cron jobs
---------

`crontab -e` (logged in as the application user) will reveal the following:

```bash
@reboot /home/mlgb/sites/mlgb/jobs/mlgbctl startnoindex > ${buildout:directory}/parts/jobs/reboot.log 2>&1
55 23 * * *     export MLGBADMINPW=blessing; ${buildout:directory}/parts/jobs/reindex.sh > ${buildout:directory}/parts/jobs/reindex.log 2>&1
```

The first line specifies that, at startup/reboot, the server should run the parts/jobs/mlgbctl script with a parameter of *startnoindex*. This will ensure that apache and solr will re-serve the application in the event of a reboot/shutdown scenario. If the reindexing needs to be run this can be done via **parts/jobs/reindex.sh**.

The second line schedules the **reindex.sh** script to run at 5 to midnight every night.


