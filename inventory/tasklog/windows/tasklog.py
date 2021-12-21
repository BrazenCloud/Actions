
import subprocess
import re
import json

original_stdout = sys.stdout # Save a reference to the original standard output

proc = subprocess.Popen(["tasklist.exe"], stdout=subprocess.PIPE)

r1 = "^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+ K)"

with open('..\\results\\results.log', 'w') as f:
    sys.stdout = f # Change the standard output to the file we created.
    for rline in iter(proc.stdout.readline, b''):
        line = rline.rstrip()
        #print('f-' + line)
        r1m = re.search(r1, line)
        if(r1m):
            print('process match:' + ' process: ' + r1m.group(1) + ' pid: '  + r1m.group(2) + ' session name: ' + r1m.group(3) + ' session: ' + r1m.group(4) + ' memory: ' + r1m.group(5))
            
    sys.stdout = original_stdout # Reset the standard output to its original value

