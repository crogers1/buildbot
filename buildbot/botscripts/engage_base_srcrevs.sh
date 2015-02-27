#!/bin/bash -x

BRANCH=$1
OFS=$IFS
IFS=','

function do_overrides () {
	name=$1
	gitr=$2
	branch=$3

	srcrev="$( git ls-remote git://$gitr/$name.git $branch | cut -f1 )";
	files=`grep -ilrF $name'.git' build/repos/xenclient-oe/`
	for file in $files;
	do
		recipe_nm="${file##*/}" #Strip leading path
		short_nm="${recipe_nm%_*}" #Strip "_git.bb"
		short_nm="${short_nm%.*}" #Strip ".bb"
		if [ $short_nm == "dm-agent" ] || [ $short_nm == "dm-wrapper" ];
   		then 
        	echo "SRCREV_pn-$short_nm-stubdom=\"$srcrev\"" >> build/conf/local.conf;
	    fi  
        #We've cloned into xenclient-oe already.
    	if [ ! $name == "xenclient-oe" ];
	    then
			#Add the overriden variable for the recipe to local.conf
			echo "SRCREV_pn-$short_nm=\"$srcrev\"" >> build/conf/local.conf
        fi
	done

}

function do_srcrev_rec () {
	name=$1
	gitr=$2
	branch=$3

	srcrev="$( git ls-remote git://$gitr/$name.git $branch | cut -f1 )";
	echo $name':'$srcrev >> srcrevs
}

#Replace autorevs for all recipes using local.conf
while read repos ;
do
	do_overrides $repos github.com/openxt master
	do_srcrev_rec $repos github.com/openxt master
done < ../../all_repos

IFS=$OFS

