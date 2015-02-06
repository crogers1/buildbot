#!/usr/bin/python
import subprocess
#TODO: Recognize when using slave
class Phase:
    def __init__(self, build_status):
        self.build_status = build_status

    def get_build_phase(self):
        proc = subprocess.Popen([str(self.build_status.builder.basedir) + "/build/build_phase.sh"], stdout=subprocess.PIPE) 
        out = proc.communicate()[0]
        return out

