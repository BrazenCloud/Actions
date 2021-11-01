import json
import subprocess
import sys


class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'


response = CResponse()
for package in ["psutil"]:
    subprocess.check_call(['pip', 'install', package])
try:
    import psutil
    response.status = "success"
    response.message = str(psutil.disk_usage(".").free) + " bytes of free space is available"
except Exception as e:
    response.status = str(e)
    response.message = "Error getting free space"

json_output = json.dumps(response, default=lambda x: x.__dict__)
print(json_output)

f = open("../results/output.json", "w+")
f.write(json_output)
f.close()