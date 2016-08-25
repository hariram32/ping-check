# Ping-Check

## Description
Simple ping-check script and web page to see the results (BASH, HTML, SVG, Javascript, JSON)

## Background
This is for my notes as to why we got here.

A friend asked me to create a simple web interface to a ping script we had running under cron. It was one of the famous 'all you have to do' things. ;-) He'd been poking around with SVG and Canvas and thought it wouldn't be too difficult to do. Well it wasn't terrible but canvas reminds me of when I started with the Atari ST and GEM. Everthing was primative and you had to be added to the screen peice meal. I'll need to look for frameworks later. But I managed to figure out how to draw a couple of boxes, populate some information about each box and update the color and information via Javascript. I used XMLHttpRequest to get the JSON file and update the information on the screen.

## Notes

* Verified with Firefox under Linux
  * Browser needs to support Javascript, AJAX (XMLHttpRequest) and SVG
  * setInterval for XMLHttpRequest is set to around 10 seconds
  * ip-results.json is expected in the http://webserver/data/ip-results.json dir

* ping-check.sh requires BASH (I think I have 4.0)
* ping goes into crontab and runs as often as necessary
* the ip-results.json needs to be copied to the web server's <webserver root>/data directory

## Installation

* cp ping-check.sh /path/bin/ping-check.sh for which every user you want running this
* add a cron entry with something like:
  */10 * * * * /path/bin/ping-check.sh && cp ip-results.json /path/www/data/ip-results.json && chmod a+r /path/www/data/ip-results.json

## ip-addr.txt
```
# Comments go here
# Fields are seperated with whitespace ("m using tabs here)
# Host_IP       Hostname

Host_IP         Hostname
192.168.24.1	hostname1
192.168.24.2	hostname2
192.168.2.1	hostname3
failed.uucp	hostname4
```

## ip-results.json
```
{
  "hosts": [
    { "name": "hostname1", "ip": "192.168.24.1", "status": "1" },
    { "name": "hostname2", "ip": "192.168.24.2", "status": "1" },
    { "name": "hostname3", "ip": "192.168.2.1", "status": "0" },
    { "name": "hostname4", "ip": "failed.uucp", "status": "2" }
  ]
  "script:": "ping-check.sh v1.1.0"
}
```
