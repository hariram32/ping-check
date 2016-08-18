#!/usr/bin/env bash

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
LIST="ip-addr.txt"
RESULT='ip-result.json'

if [ ! -f ${LIST} ]; then
    echo "IP Address file not found: ${LIST}" #| mutt -s "Ping check: IP Address file not found" ${EMAIL}
    echo -e "{\n  \"hosts\": [\n  ],\n  \"script:\": \"ping-check.sh\"\n}" > ip-results.json
    #echo "{ }" > ip-results.json
    exit 2
fi

while read ip
do
    result=$(ping -c 3 $ip 2>&1)
    # xc can be 0, 1 or 2
    xc=$?
    case ${xc} in
	1)
	    # Send email
	    echo -e "I was unable to ping ${ip}i\n\n${result}" #| mutt -s "Ping check for ${ip} failed" ${EMAIL}
	    xc=0
	    ;;
	0)
	    xc=1
	    ;;
	2)
	    xc=2
	    ;;
    esac
    if [ -n "${s}" ]; then
	s="${s},\n    { \"ip\": \"${ip}\", \"status\": \"${xc}\" }"
    else
	s="    { \"ip\": \"${ip}\", \"status\": \"${xc}\" }"
    fi
done < ${LIST}
echo -e "{\n  \"hosts\": [\n${s}\n  ],\n  \"script:\": \"ping-check.sh\"\n}" > ip-results.json

# {
#   "hosts": [
#     { "ip": "192.168.24.1", \"status\": "1" },
#     { "ip": "192.168.24.2", \"status\": "1" },
#     { "ip": "192.168.2.1", \"status\": "0" },
#     { "ip": "failed.uucp", \"status\": "2" }
#   ],
#   "script:": "ping-check.sh"
# }
