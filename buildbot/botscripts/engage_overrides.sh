#!/bin/bash
#
#	For each repository that we've indicated an override for, grep for the list 
#	of all bb recipes that use that repo. Replace the git mirror and srcrev with
#	the values specified in the buildbot gui.
#
#

set -e

REPO=''
URL=''
SRCREV=''

if [ ! -e "/tmp/overrides" ];
then
	exit 0;
fi

while read line ;
do
	REPO="$( cut -d ',' -f1 <<< "$line" )";
	URL="$( cut -d ',' -f2 <<< "$line" )";

	grep -ilr $REPO'.git' build/repos/xenclient-oe > /tmp/bbfiles

	#if [ $REPO == "xenclient-oe" ];	#Manually override the xenclient-oe repo
	#then
#		cd build/repos/xenclient-oe
#		git remote add other $URL
#		git fetch other
#		git checkout other/master
		#git checkout $SRCREV
#		cd ../../../
#	fi

	while read filename ;
	do
		sed -i -e "s@\${OPENXT_GIT_MIRROR}@$URL@g" $filename;
		#Can't use the replaced srcrev from github if using a non-default URL.
		sed -i "s/\${OPENXT_GIT_PROTOCOL}/git/g" $filename;
	done < /tmp/bbfiles

done < /tmp/overrides
