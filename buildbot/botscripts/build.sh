#!/bin/bash -ex

BUILDID=$1
BRANCH=$2
LAYERS=$3

umask 0022
cd build
#Extra case for openxt override
OPENXT_OVERRIDE=`grep -ir 'openxt' /tmp/overrides | cut -f1 -d ','`
if [[ $OPENXT_OVERRIDE == 'openxt' ]];
then
	REPO=`grep -ir 'openxt' /tmp/overrides | cut -f2 -d ','`
	git clone git://$REPO/openxt.git
else
	git clone file:///home/build/builder/build/git/openxt.git
fi
cd openxt
cp -r ../../certs .
mv /tmp/git_heads_$BUILDID git_heads
cp example-config .config
cat <<EOF >> .config
NAME_SITE="ext"
OPENXT_GIT_MIRROR="/home/build/builder/build/git"
OPENXT_GIT_PROTOCOL="file"
REPO_PROD_CACERT="/home/build/builder/build/certs/prod-cacert.pem"
REPO_DEV_CACERT="/home/build/builder/build/certs/dev-cacert.pem"
REPO_DEV_SIGNING_CERT="/home/build/builder/build/certs/dev-cacert.pem"
REPO_DEV_SIGNING_KEY="/home/build/builder/build/certs/dev-cakey.pem"
WIN_BUILD_OUTPUT="buildbot@192.168.0.10:/home/build/win"
SYNC_CACHE_OE=192.168.0.10:/home/build/oe
BUILD_RSYNC_DESTINATION=127.0.0.1:/home/storage/builds
NETBOOT_HTTP_URL=http://192.99.200.146/builds
EOF
OE_OVERRIDE=`grep -ir 'xenclient-oe' /tmp/overrides | cut -f1 -d ','`
if [[ $OE_OVERRIDE == 'xenclient-oe' ]];
then
	REPO=`grep -ir 'xenclient-oe' /tmp/overrides | cut -f2 -d ','`
	echo "Overriding xenclient-oe, repo: "$REPO
	cat <<EOF >> build/local.settings
META_SELINUX_REPO=file:///home/build/builder/build/git/meta-selinux.git
EXTRA_REPO=file:///home/build/builder/build/git/xenclient-oe-extra.git
EXTRA_DIR=extra
EXTRA_TAG="$BRANCH"
XENCLIENT_REPO=git://$REPO/xenclient-oe.git
XENCLIENT_TAG="$BRANCH"
EOF
fi
./do_build.sh -i $BUILDID -s setupoe,sync_cache
if [[ $LAYERS != 'None' ]];
then
	../../engage_layers.sh $LAYERS
fi
../../engage_overrides.sh
../../engage_srcrevs.sh $BRANCH
./do_build.sh -i $BUILDID | tee build.log
ret=${PIPESTATUS[0]}
cd -
cd -

exit $ret
