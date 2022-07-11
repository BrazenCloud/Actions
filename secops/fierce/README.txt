Using
Let's start with something basic:

$ fierce --domain google.com --subdomains accounts admin ads
Traverse IPs near discovered domains to search for contiguous blocks with the --traverse flag:

$ fierce --domain facebook.com --subdomains admin --traverse 10
Limit nearby IP traversal to certain domains with the --search flag:

$ fierce --domain facebook.com --subdomains admin --search fb.com fb.net
Attempt an HTTP connection on domains discovered with the --connect flag:

$ fierce --domain stackoverflow.com --subdomains mail --connect
Exchange speed for breadth with the --wide flag, which looks for nearby domains on all IPs of the /24 of a discovered domain:

$ fierce --domain facebook.com --wide
Zone transfers are rare these days, but they give us the keys to the DNS castle. zonetransfer.me is a very useful service for testing for and learning about zone transfers:

$ fierce --domain zonetransfer.me
To save the results to a file for later use we can simply redirect output:

$ fierce --domain zonetransfer.me > output.txt
Internal networks will often have large blocks of contiguous IP space assigned. We can scan those as well:

$ fierce --dns-servers 10.0.0.1 --range 10.0.0.0/24
Check out --help for further information:

$ fierce --help