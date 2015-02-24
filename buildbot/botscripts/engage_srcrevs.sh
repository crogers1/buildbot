#!/bin/bash

BRANCH=$1

while read repos ;
do
	SRCREV="$( git ls-remote git://github.com/openxt/$repos.git $BRANCH | cut -f1 )";
	FILES=`grep -ilrF $repos'.git' build/repos/xenclient-oe/`
	echo $repos":"$SRCREV >> srcrevs
	for file in $FILES;
	do
		NAME="${file##*/}" #Strip leading path
		SHORTNM="${NAME%_*}" #Strip "_git.bb"
		SHORTNM="${SHORTNM%.*}" #Strip ".bb"
		#These recipes don't have the .git repo in their file, add them explicitly
		if [ $SHORTNM == "dm-agent" ] || [ $SHORTNM == "dm-wrapper" ];
		then
			echo "SRCREV_pn-$SHORTNM-stubdom=\"$SRCREV\"" >> build/conf/local.conf;
		fi
		#We've cloned into xenclient-oe already.
		if [ ! $repos == "xenclient-oe" ];
		then
			#Add the overriden variable for the recipe to local.conf
			echo "SRCREV_pn-$SHORTNM=\"$SRCREV\"" >> build/conf/local.conf 
		fi
	done
done < ../../repo.list
#done < repo.list



