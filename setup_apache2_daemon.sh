#!/usr/bin/bash

NAME="apache2"
DESC="Cygwin Apache2"

readonly DAEMON_PATH="--path /usr/sbin/httpd"
readonly DAEMON_ARGS="--args -DFOREGROUND"
readonly DAEMON_EVAR="--env CYGWIN=server"
readonly DAEMON_EVAL="ntsec binmode server"
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

if [ $1 = "clear" ]
then
	exit 127
fi

# install and start

echodo cygrunsrv --list --verbose
echodo cygrunsrv --install $NAME --desc "$DESC" \
	$DAEMON_WDIR $DAEMON_PATH $DAEMON_ARGS --env CYGWIN="$DAEMON_EVAL"
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
