#!/usr/bin/bash

########## CONFIG

PORT=3111
REDMINE_DIR="$HOME/redmine-4.1.1"

export        CPATH=c:\Program\ Files\ImageMagick-7.0.10-Q16-HDRI\include
export LIBRARY_PATH=c:\Program\ Files\ImageMagick-7.0.10-Q16-HDRI\lib
#export CPATH=/cygdrive/c/Program\ Files/ImageMagick-7.0.10-Q16-HDRI/include
#export LIBRARY_PATH=/cygdrive/c/Program\ Files/ImageMagick-7.0.10-Q16-HDRI/lib

########## DEFINE

readonly THIS_MONTH=`date '+%Y%m'`
readonly LOG_FILE="log/webrick.log.${THIS_MONTH}"
readonly PID_FILE="/var/run/redmine.pid"

########## FUNCTION

check_webrick_log()
{
	local sleep_time
	sleep_time=$1

	while date '+warting for start: %H:%M:%S'
	do
		if tail -5 $LOG_FILE | egrep 'INFO  WEBrick::HTTPServer#start: pid=[0-9]* port=3000'
		then
			break
		fi
		sleep $sleep_time
	done
}

########## MAIN/optoins

info()
{
	tail -10 $LOG_FILE | egrep ' INFO ' 
}

start()
{
	if [ -f $PID_FILE ]
	then
		echo -e "\e[31mredmine is run!\e[0m"
		echo -e "\e[33usage: this_script.sh restart\e[0m"
		return 1
	fi

	bundle exec rails server webrick -e production -p ${PORT:-3000} >> $LOG_FILE 2>&1 &
	echo $! > $PID_FILE

#	(check_webrick_log 29) &
}

stop()
{
	kill `cat $PID_FILE`
	rm -f $PID_FILE
}

########## MAIN

main()
{
	cd $REDMINE_DIR

	case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	info)
		info
		;;
	*)
		echo -e "\e[33musage: this_script start|stop|restart|info\e[0m"
		;;
	esac

	return 0
}

########## EXEC

main "$@"
exit $?

########## END	

#set CPATH=C:\Program Files (x86)\ImageMagick-6.7.9-Q16\include
#set LIBRARY_PATH=C:\Program Files (x86)\ImageMagick-6.7.9-Q16\lib
