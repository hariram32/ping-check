#!/usr/bin/env bash

VERSION='v1.2.3'

# JSON
# Good
# {
#   "x": "1",
#   "y": "0"
# }
# Bad
# {
#   'x': '1',
#   'y': '0'
# }
 
# Read in from the ip-list.txt
# ping each addr
# email on failure
EMAIL="ncherry@linuxha.com"
# when run from cron this will look in your home directory
# when run from the command line, from the current directory
LIST="${LIST-ip-addr.txt}"
RESULTS="${RESULTS-/var/www/html/data/ip-results.json}"

if [ ! -f ${LIST} ]; then
    echo "IP Address file not found: ${LIST}" #| mutt -s "Ping check: IP Address file not found" ${EMAIL}
    echo -e "{\n  \"hosts\": [\n  ],\n  \"script:\": \"ping-check.sh\"\n}" > ${RESULTS}
    exit 2
fi

# the ip-addr.txt format
# 1st <white space> 2nd
# IP                Hostname
# egrep skips lines that start with a # (comments) and blank lines
egrep -v '^#|^$' ${LIST} | while read ip nom href
do
    result=$(ping -c 3 $ip 2>&1)
    # xc can be 0, 1 or 2
    xc=$?
    case ${xc} in
	1)
	    # Ping failed, Send email
	    echo -e "I was unable to ping ${nom} ${ip}i\n\n${result}" #| mutt -s "Ping check for ${ip} failed" ${EMAIL}
	    xc=0
	    ;;
	0)
	    # Ping passed
	    xc=1
	    ;;
	2)
	    # Ping failed because of other reasons (like unknown host)
	    xc=2
	    ;;
    esac
    if [ -n "${s}" ]; then
	s="${s},\n    { \"name\": \"${nom}\", \"ip\": \"${ip}\", \"state\": \"${xc}\", \"href\": \"${href}\" }"
    else
	s="    { \"name\": \"${nom}\", \"ip\": \"${ip}\", \"state\": \"${xc}\", \"href\": \"${href}\" }"
    fi
done

# Sample input (ip-addr.txt)
# 192.168.24.1	hostname1
# 192.168.24.2	hostname2
# 192.168.2.1	hostname3
# failed.uucp	hostname4

# send the results to the RESULTS file, in JSON format
echo -e "{\n  \"hosts\": [\n${s}\n  ],\n  \"script:\": \"ping-check.sh ${VERSION}\"\n}" > ${RESULTS}

# Sample output (ip-results.json)
# {
#   "hosts": [
#     { "name": "hostname1", "ip": "192.168.24.1", "state": "1", "href" : "a/index.html" },
#     { "name": "hostname2", "ip": "192.168.24.2", "state": "1", "href" : "b/index.html" },
#     { "name": "hostname3", "ip": "192.168.2.1",  "state": "0", "href" : "c/index.html" },
#     { "name": "hostname4", "ip": "failed.uucp",  "state": "2", "href" : "d/index.html" }
#   ],
#   "script:": "ping-check.sh v1.2.3"
# }
