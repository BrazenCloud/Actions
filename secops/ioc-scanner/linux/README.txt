Indicators of compromise (IoC) scanning tool.
This script can take a blob of text that "should" contain MD5 hashes
and scan a machine looking for files that match.  It will report the
location of each mataching file as well as a summary containing the
tallies by hash.  Execution time is also reported.
This script should be run as a priveledged user.
Usage:
  ioc-scan [--log-level=LEVEL] [--stdin | --file=hashfile] [--target=root]
  ioc-scan (-h | --help)
Options:
  -h --help              Show this message.
  -f --file=hashfile     Get IOC hashes from specified file.
  -L --log-level=LEVEL   If specified, then the log level will be set to
                         the specified value.  Valid values are "debug", "info",
                         "warning", "error", and "critical". [default: warning]
  -s --stdin             Get IOC hashes from stdin.
  -t --target=root       Scan target root directory. [default: /]