MLGB
----

MLGB runs inside a virtualenv within the mlgb home directory.

The Django controller scripts are located in **/home/mlgb/sites/mlgb/bin**

The Django eggs are located in the buildout cache at **/home/mlgb/.buildout/eggs/Django-1.2-py2.7.egg/** (this is appended to the syspath in mlgb.wsgi)

The codebase is located in **/home/mlgb/sites/mlgb/mysite/**

The static media is located in **/home/mlgb/sites/mlgb/static/**

Solr, apache and the indexing cron jobs are in the parts directory located at **/home/mlgb/sites/mlgb/parts/**

MySQL runs on **localhost:3306** and can be access via the mysql CLI. *This can be changed in development/production.cfg.*

Solr runs on **127.0.1.1:1234** and can be access on the server via lynx. *This can be changed in development/production.cfg.*

Run scripts
-----------

These are all located in **/home/mlgb/sites/mlgb/parts/jobs**.

### reindex.sh 

This will run the reindexing process that is scheduled via cron.

### mlgbctl start | restart | stop | startnoindex

start, restart and stop will control solr, apache and (in the case of start) run the reindex scripts.

startnoindex will start solr and apache.

Log files
---------

Log files for solr are in **parts/solr/logs/**

Log files for reindexing are in **parts/jobs/**

In the event of a reboot there is a reboot log in **parts/jobs/**

Cron jobs
---------

crontab -e will reveal the following:

```bash
@reboot /home/mlgb/sites/mlgb/jobs/mlgbctl startnoindex > ${buildout:directory}/parts/jobs/reboot.log 2>&1
55 23 * * *     export MLGBADMINPW=blessing; ${buildout:directory}/parts/jobs/reindex.sh > ${buildout:directory}/parts/jobs/reindex.log 2>&1
```

The first line specifies that, at startup/reboot, the server should run the parts/jobs/mlgbctl script with a parameter of startnoindex. This will ensure that apache and solr will re-serve the application in the event of a reboot/shutdown scenario. If the reindexing needs to be run this can be done via **parts/jobs/reindex.sh**.

The second line schedules the **reindex.sh** script to run at 5 to midnight every night.

