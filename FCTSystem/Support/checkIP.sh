#!/bin/sh
# Ping

flag=0
constStr="1 packets transmitted, 1 packets received, 0.0% packet loss"

while echo "Check Started" > Null
do
#    retStr=`ping -c1 -t1 $1 | grep 0.0%`
##    pstr=`ls $2 | grep '$2'`
#    if [ "$retStr" = "$constStr" ]
#    then
##        if ls $2
##        then
##            continue
##        else
#            touch $2
##        fi
#
#    else
##        if ls $2
##        then
#            rm $2
##        fi
#    fi

#    retStr=`ping -c1 -t1 $1 | grep 0.0%`
#    printf $retStr >> $2

    ping -c1 -t1 $1 | grep 0.0%
    sleep 2
done