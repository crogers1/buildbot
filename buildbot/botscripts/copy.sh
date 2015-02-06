#!/bin/bash

#
#	After a successful build, create a unique build directory and copy installer.iso and 
#	packages.main into the directory to be accessed later.
#

#umask 0022
#BUILD_DIR='build-'`cat /tmp/build_num`
#cp build/openxt/build-output/openxt-dev--master/iso/installer.iso /var/www/openxt/installer.iso
#tar cvf build/openxt/build-output/openxt-dev--master/repository/packages.main.tar build/openxt/build-output/openxt-dev--master/repository/packages.main
#gzip build/openxt/build-output/openxt-dev--master/repository/packages.main.tar
#mkdir /var/www/openxt/$BUILD_DIR
#cp build/openxt/build-output/openxt-dev--master/iso/installer.iso /var/www/openxt/$BUILD_DIR
#cp build/openxt/build-output/openxt-dev--master/repository/packages.main.tar.gz /var/www/openxt/$BUILD_DIR

BUILDNUM=$1
BRANCH=$2
umask 0022
rsync -aR build/openxt/build-output output/$BUILD_DIR
#cp build/openxt/build-output/openxt-dev--master/iso/installer.iso output/$BUILD_DIR/installer.iso
#tar -C build/openxt/build-output/openxt-dev--master/repository/ -cvf packages.main.tar packages.main
#if [ ! -e 'packages.main.tar.gz' ]; 
#then
#	gzip packages.main.tar;
#fi
#mv packages.main.tar.gz output/$BUILD_DIR
