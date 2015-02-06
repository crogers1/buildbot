#!/bin/bash

umask 0022

CLEAN=`cat /tmp/clean`

if [ $CLEAN == "1" ];
then
	rm -rf build
	mkdir build
	rm -rf /tmp/bbfiles
	echo "Done Cleaning!"
else
	echo "Did not clean."
fi

rm -rf /tmp/clean
