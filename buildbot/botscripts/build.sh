#!/bin/bash -ex

#
#	Buildbot build step script.  On a clean build it clones into openxt.git and
#	configures the directory for a build.  Additionally, we invoke replace_auotrevs
#	and engage_overrides to build from static srcrevs (or any user specified repos/srcrevs)
#	On a rebuild, we determine the last step where the build left off and invoke do_build.sh
#	on all remaining steps
#

umask 0022
STEPS="setupoe,initramfs,stubinitramfs,dom0,uivm,ndvm,syncvm,sysroot,installer,installer2,syncui,source,sdk,license,sourceinfo,ship"

BUILDNUM=$1
BRANCH=$2

python out-dir.py

#If there is no last.step, assume we are starting from a clean build.
if [ ! -e "build/openxt/last.step" ];
then
	echo "Build from scratch."
	if [ ! -d "build" ];then
		mkdir build
	fi
	BASE_DIR=`pwd`
	cd build
	git clone file://$BASE_DIR/git/openxt.git
	cd openxt
	cp -r ../../certs .
	cp example-config .config
	cat <<EOF >> .config
	OPENXT_GIT_PROTOCOL="file"
	OPENXT_GIT_MIRROR="$BASE_DIR/git"
	REPO_PROD_CACERT="$BASE_DIR/certs/prod-cacert.pem"
	REPO_DEV_CACERT="$BASE_DIR/certs/dev-cacert.pem"
	REPO_DEV_SIGNING_CERT="$BASE_DIR/certs/dev-cacert.pem"
	REPO_DEV_SIGNING_KEY="$BASE_DIR/certs/dev-cakey.pem"
	BRANCH="$BRANCH"
EOF
#	sed -i "s/BBFLAGS=\"\"/BBFLAGS=\"-k\"/g" do_build.sh	#Set continue flag automatically.
	./do_build.sh -s setupoe
	echo 'BUILD_ARCH="i686"' >> $BASE_DIR/build/openxt/build/conf/local.conf
	echo 'INHERIT+="buildhistory"' >> $BASE_DIR/build/openxt/build/conf/local.conf
	echo 'BUILDHISTORY_COMMIT = "1"' >> $BASE_DIR/build/openxt/build/conf/local.conf
	#../../replace_autorevs.sh
	../../engage_overrides.sh
	./do_build.sh -i $BUILDNUM | tee build.log
else
#If we do have last.step, assume we want to pick up where we left off (roughly) in the build
	echo "Rebuilding where previous build left off." 
	OIFS=$IFS;
	IFS=','; export IFS;
	cd build
	cd openxt
	LAST_STEP=`cat last.step`
	if [ $LAST_STEP == "" ];
	then
		echo "Error determining where previous build left off."
		exit -1
	fi
	REMAINING=$STEPS
	for i in $STEPS;
	do
		if [ $i == $LAST_STEP ];
		then
			break;
		else
			REMAINING=`echo "$REMAINING" | cut -d "," -f 2-`
		fi
	done
	IFS=$OIFS; export IFS;

	./do_build.sh -i $BUILDNUM -s $REMAINING | tee build.log
fi

ret=${PIPESTATUS[0]}
LAST=`grep -ir "STARTING STEP" build.log | tail -1 | cut -d " " -f3`

#If the info file exists theres a high chance the build is done.
#if [ ! -e "build-output/openxt-dev--master/info" ];
#then
#	echo $LAST > last.step
#fi
echo $LAST > last.step

cd -
cd -

exit $ret






