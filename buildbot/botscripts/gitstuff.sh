#!/bin/bash
#
#	Grab any the names of any tags and branches in the openxt.git repo.
#	Will be used to specifiy a build in buildbot since those branches and
#	tags will be uniform across all repos
#


git ls-remote --heads --tags https://github.com/openxt/openxt.git > /tmp/git-ls 
