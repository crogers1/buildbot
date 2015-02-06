#!/bin/bash

set -e

grep -ir "STARTING STEP" /snd/buildbot/build/build/openxt/build.log | tail -1 | cut -d " " -f3
