#!/usr/bin/bash

NAME="cron"
DESC="Cygwin Cron"

readonly DAEMON_PATH="--path /usr/sbin/cron"
readonly DAEMON_ARGS="-n -x ext,sch,proc,pars,load,misc"
readonly DAEMON_WDIR="--chdir /var/empty"

########## FUNCTION

echodo()
{
	echo "########## CMD[$@]"
	"$@"
	return $?
}

########## MAIN

# stop and remove

SERVICE_NAME=`cygrunsrv --list | egrep -i ${NAME}`

if [ -z "${SERVICE_NAME}" ]
then
	true
else
	NAME=$SERVICE_NAME
	echodo cygrunsrv --list --verbose
	echodo cygrunsrv --stop $NAME
	echodo cygrunsrv --query $NAME --verbose
	echodo cygrunsrv --remove $NAME
fi

if [ "$1" = "reset" ]
then
	exit
fi

# install and start

echodo cygrunsrv --list --verbose
echodo cygrunsrv --install $NAME --desc "$DESC" $DAEMON_WDIR $DAEMON_PATH --args "$DAEMON_ARGS"
echodo cygrunsrv --query $NAME --verbose
while true
do
	echodo sleep 2
	if echodo cygrunsrv --start $NAME 
	then
		echodo echo $?
		echodo cygrunsrv --list --verbose
		break
	fi
done
