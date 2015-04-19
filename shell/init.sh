#!/bin/sh
QUIET=""
if [ "$1" = "-q" ]; then
    QUIET="-qq"
fi
LOG="/tmp/init.sh.log"

apt-get -y $QUIET update >> $LOG 2>&1 || exit $?
apt-get -y $QUIET install build-essential software-properties-common >> $LOG 2>&1 || exit $?
add-apt-repository -y ppa:ondrej/php5 >> $LOG 2>&1 || exit $?
apt-get -y $QUIET update >> $LOG 2>&1 || exit $?
apt-get -y $QUIET autoremove >> $LOG 2>&1 || exit $?
