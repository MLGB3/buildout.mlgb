#!/bin/sh

# Prerequisites:
# 1. Solr needs to be installed at /usr/local/solr/example
# 2. daemon needs to be installed
# 3. Script needs to be executed by root

# This script will launch Solr in a mode that will automatically respawn if it
# crashes. Output will be sent to /var/log/solr/solr.log. A pid file will be 
# created in the standard location.

startnoindex () {
    echo -n "Starting solr $(date)..."

    # start solr daemon
    daemon --chdir='${buildout:directory}/parts/solr/' --command "java -Dsolr.solr.home=${buildout:directory}/parts/solr/solr -jar start.jar" --respawn --output=${buildout:directory}/var/logs/solr.log --name=solr --verbose
    RETVAL=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "Solr start failed. See error code for more information."
    fi

    echo -n "Starting apache..."

    # start apache
    ${buildout:directory}/parts/apache/bin/apachectl start

    RETVAL3=$?

    if [ $RETVAL3 = 0 ]
    then
        echo "done."
    else
        echo "Apache start failed. See error code for more information."
    fi

    return $RETVAL
}

start () {
    echo -n "Starting solr $(date)..."

    # start solr daemon
    daemon --chdir='${buildout:directory}/parts/solr' --command "java -Dsolr.solr.home=${buildout:directory}/parts/solr/solr -jar start.jar" --respawn --output=${buildout:directory}/var/logs/solr.log --name=solr --verbose
    RETVAL=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "Solr start failed. See error code for more information."
    fi

    echo -n "Running reindexing..."

    # run reindexing
    export MLGBADMINPW=blessing; ${buildout:directory}/parts/jobs/reindex.sh > ${buildout:directory}/var/logs/reindex.log 2>&1
    RETVAL2=$?

    if [ $RETVAL2 = 0 ]
    then
        echo "done."
    else
        echo "Reindex.sh start failed. See error code for more information."
    fi

    echo -n "Starting apache..."

    # start apache
	${buildout:directory}/parts/apache/bin/apachectl start

    RETVAL3=$?

    if [ $RETVAL3 = 0 ]
    then
        echo "done."
    else
        echo "Apache start failed. See error code for more information."
    fi

    return $RETVAL
}

stop () {
    # stop daemon
    echo -n "Stopping solr $(date)..."

    # stop solr daemon
    daemon --stop --name=solr  --verbose
    RETVAL=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "Solr stop failed. See error code for more information."
    fi

    echo -n "Stopping apache..."

    # stop apache
	${buildout:directory}/parts/apache/bin/apachectl stop

    RETVAL2=$?

    if [ $RETVAL2 = 0 ]
    then
        echo "done."
    else
        echo "Apache stop failed. See error code for more information."
    fi

    return $RETVAL
}


restart () {

    echo "Restarting solr $(date)..."

	# restart solr daemon
    daemon --restart --name=solr  --verbose

    echo "Restarting apache..."

    # restart apache
    ${buildout:directory}/parts/apache/bin/apachectl restart
}


status () {

    echo "Solr daemon status..."

    # report on the status of the daemon
    daemon --running --verbose --name=solr
    return $?
}


case "$1" in
    startnoindex)
        startnoindex
    ;;    
    start)
        start
    ;;
    status)
        status
    ;;
    stop)
        stop
    ;;
    restart)
        restart
    ;;
    *)
        echo $"Usage: solr {start|status|stop|restart}"
        exit 3
    ;;
esac

exit $RETVAL

