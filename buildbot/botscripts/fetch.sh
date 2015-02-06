#!/bin/bash
#
#	Iterate through the list of openxt github mirrors and create/update a set of local 
#	mirrors.
#

for i in git/*.git; do
    echo "Fetching `basename $i`..."
    cd $i
    git fetch --all
    cd - > /dev/null
done
