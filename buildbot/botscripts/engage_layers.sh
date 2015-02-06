#!/bin/bash 

set -ex

LAYERS=$1

OIFS=$IFS
IFS=','

#sed -i "s/  \"//g" build/conf/bblayers.conf
#sed -i "/^$/d" build/conf/bblayers.conf
head build/conf/bblayers.conf -n -3 > build/conf/bblayers.conf.tmp
mv build/conf/bblayers.conf.tmp build/conf/bblayers.conf
for pair in $LAYERS;
do
	LAYER_NAME=`echo $pair | cut -f 1 -d ':'`
	LAYER_REPO=`echo $pair | cut -f 2 -d ':'`	
	echo "  \${TOPDIR}/repos/$LAYER_NAME \\" >> build/conf/bblayers.conf
	
	cd build/repos
	git clone git://$LAYER_REPO
	cd ../../
	
done

echo "  \"" >> build/conf/bblayers.conf

IFS=$OIFS


