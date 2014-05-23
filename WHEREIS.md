MLGB
----

MLGB runs inside a virtualenv within the /home/mlgb/sites/mlgb/ directory. It can be activated and deactivated as follows:

```bash
. bin/activate
deactivate
```

Everything within the virtualenv, including Apache, runs under the application user, **mlgb**. Sudo rights are available to the developer logged into the machine and it may be necessary to switch from time to time. However, ensure any files produced as sudo/your own login are chowned as mlgb, the application user.

Where is...?
------------

Everything exists under **/home/mlgb/**. The virtualenv python install is in **/home/mlgb/python/** (this python is specific to the application and different to the system one). The application itself resides at **/home/mlgb/sites/mlgb/**.

#### **Django**

The Django controller scripts are located in **/home/mlgb/sites/mlgb/bin/**

The Django eggs are located in the buildout cache at **/home/mlgb/.buildout/eggs/Django-1.2-py2.7.egg/** (this is appended to the syspath in /home/mlgb/sites/mlgb/mysite/apache/mlgb.wsgi)

The codebase is located in **/home/mlgb/sites/mlgb/mysite/**

Django settings.py and all apache WSGI settings are in **/home/mlgb/sites/mlgb/mysite/apache/**

A list of all installed Django eggs can be found via the Omelette directory in **parts/omelette/**.

#### **Media**

The static media is located in **/home/mlgb/sites/mlgb/static/**

The admin media is currently located at **/home/mlgb/.buildout/eggs/Django-1.2-py2.7.egg/django/contrib/admin/media/** though this may change

#### **Solr, Apache, MySQL**

Solr, apache and the indexing cron jobs are in the parts directory located at **/home/mlgb/sites/mlgb/parts/**

MySQL runs on **localhost:3306** and can be accessed via the mysql CLI. *This can be changed in development/production.cfg.*

Solr runs on **127.0.1.1:1234** and can be access on the server via lynx. *This can be changed in development/production.cfg.*


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

In the event of a reboot there is a reboot log in **parts/jobs/**

Cron jobs
---------

`crontab -e` (logged in as the application user) will reveal the following:

```bash
@reboot /home/mlgb/sites/mlgb/jobs/mlgbctl startnoindex > ${buildout:directory}/parts/jobs/reboot.log 2>&1
55 23 * * *     export MLGBADMINPW=blessing; ${buildout:directory}/parts/jobs/reindex.sh > ${buildout:directory}/parts/jobs/reindex.log 2>&1
```

The first line specifies that, at startup/reboot, the server should run the parts/jobs/mlgbctl script with a parameter of *startnoindex*. This will ensure that apache and solr will re-serve the application in the event of a reboot/shutdown scenario. If the reindexing needs to be run this can be done via **parts/jobs/reindex.sh**.

The second line schedules the **reindex.sh** script to run at 5 to midnight every night.


