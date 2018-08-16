#!/bin/bash
result=`/tools/do_update_mbed.sh result`
echo "${result}"

if [ "$result" == "OK" ] ; then
	exit 0
else
	exit 1
fi
