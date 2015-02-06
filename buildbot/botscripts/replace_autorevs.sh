#!/bin/bash
#
#	For each repo in the list of openxt repos, grep for all the bb recipes
# 	that directly use that repo.  Replace the srcrev to the head of the tree
#	to use the most recent revision but not use AUTOREV (which could change during the course
#	of the build)
#


BRANCH="$( cat /tmp/branch_sel )"

while read repos ;
do
	SRCREV="$( git ls-remote git://github.com/openxt/$repos.git $BRANCH | cut -f1 )";
	grep -ilrF $repos'.git' build/repos/xenclient-oe/ > /tmp/bbfiles
	
	while read filename ;
    do
        sed -i "s/\${AUTOREV}/$SRCREV/g" $filename;
	done < /tmp/bbfiles
done < ../../repo.list
	
