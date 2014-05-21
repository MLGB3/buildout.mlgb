#!/bin/sh

# Prerequisites:
# 1. Solr needs to be installed at /usr/local/solr/example
# 2. daemon needs to be installed
# 3. Script needs to be executed by root

# This script will launch Solr in a mode that will automatically respawn if it
# crashes. Output will be sent to /var/log/solr/solr.log. A pid file will be 
# created in the standard location.

start () {
    echo -n "Starting solr..."

    # start solr daemon
    daemon --chdir='${buildout:directory}/parts/solr/' --command "java -Dsolr.solr.home=${buildout:directory}/parts/solr/solr -jar start.jar" --respawn --output=${buildout:directory}/parts/solr/logs/solr.log --name=solr --verbose
    RETVAL=$?

    echo -n "Running reindexing..."

    # run reindexing
    export MLGBADMINPW=blessing; ${buildout:directory}/parts/jobs/reindex.sh > ${buildout:directory}/parts/jobs/reindex.log 2>&1
    RETVAL2=$?

    echo -n "Starting apache..."

    # start apache
	${buildout:directory}/parts/apache/bin/apachectl start

    RETVAL3=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "Solr start failed. See error code for more information."
    fi

    if [ $RETVAL2 = 0 ]
    then
        echo "done."
    else
        echo "Reindex.sh start failed. See error code for more information."
    fi

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
    echo -n "Stopping solr..."

    # stop solr daemon
    daemon --stop --name=solr  --verbose
    RETVAL=$?

    echo -n "Stopping apache..."

    # stop apache
	${buildout:directory}/parts/apache/bin/apachectl stop
	$RETVAL2=$?

    if [ $RETVAL = 0 ]
    then
        echo "done."
    else
        echo "Solr stop failed. See error code for more information."
    fi

    if [ $RETVAL2 = 0 ]
    then
        echo "done."
    else
        echo "Apache stop failed. See error code for more information."
    fi

    return $RETVAL
}


restart () {

    echo -n "Restarting solr..."

	# restart solr daemon
    daemon --restart --name=solr  --verbose

    echo -n "Restarting apache..."

    # restart apache
    ${buildout:directory}/parts/apache/bin/apachectl restart
}


status () {

    echo -n "Solr daemon status..."

    # report on the status of the daemon
    daemon --running --verbose --name=solr
    return $?
}


case "$1" in
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