#!/usr/bin/python

import os
from json import loads
from urllib import urlopen

BUILDBOT_URL = "http://127.0.0.1:8010/json/builders"

def main():
    tdoc = loads(urlopen(BUILDBOT_URL).read())
    for builder in tdoc:
        doc = tdoc[builder]
        cur_builds = doc['currentBuilds']
        #Just make output directories for all current builds
        #If one already exists just keep going.
        for i in cur_builds:
            try:
                f = open('/tmp/build_num', 'w')
                f.write(str(i))
                f.close()
            except OSError:
                continue



main()
