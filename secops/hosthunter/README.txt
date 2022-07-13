
HostHunter v1.6
A tool to efficiently discover and extract hostnames providing a large set of target IP addresses. HostHunter utilises simple OSINT techniques to map IP addresses with virtual hostnames. It generates a CSV or TXT file containing the results of the reconnaissance.

Latest version of HostHunter also takes screenshots of the target web applicatiinos. This functionality is currently in beta.


./hosthunter.py targets.txt -h
usage: hosthunter.py [-h] [-f FORMAT] [-o OUTPUT] [-sc] [-t TARGET] [-V] [targets]

[?] HostHunter v1.6 - Help Page

positional arguments:
  targets               Sets the path of the target IPs file.

optional arguments:
  -h, --help            show this help message and exit
  -f FORMAT, --format FORMAT
                        Choose between CSV and TXT output file formats.
  -o OUTPUT, --output OUTPUT
                        Sets the path of the output file.
  -sc, --screen-capture
                        Capture a screenshot of any associated Web Applications.
  -t TARGET, --target TARGET
                        Scan a Single IP.
  -V, --version         Displays the current version.

Author: Andreas Georgiou (@superhedgy)