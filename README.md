# Ping-Check

## Description
Simple ping-check script and web page to see the results (BASH, HTML5, Javascript, JSON)

## Background
This is for my notes as to why we got here.

A friend asked me to create a simple web interface to a ping script we had running under cron. It was one of the famous 'all you have to do' things. ;-) He'd been poking around with SVG and Canvas and thought it wouldn't be too difficult to do. Well it wasn't terrible but canvas reminds me of when I started with the Atari ST and GEM. Everthing was primative and you had to be added to the screen peice meal. I'll need to look for frameworks later. But I managed to figure out how to draw a couple of boxes, populate some information about each box and update the color and information via Javascript. I used XMLHttpRequest to get the JSON file and update the information on the screen.

Same friend asked if it was possible to make each canvas clickable (linked to another HTML page). Short answer is yes. The latest check.html now has this feature.

## Notes

* Verified with Firefox under Linux
  * Browser needs to support Javascript, AJAX (XMLHttpRequest) and HTML5 canvas (not SVG in this)
  * setInterval for XMLHttpRequest is set to around 10 seconds
  * ip-results.json is expected in the http://webserver/data/ip-results.json dir

* ping-check.sh requires BASH (I think I have 4.0)
* ping goes into crontab and runs as often as necessary
* the ip-results.json needs to be copied to the web server's <webserver root>/data directory. ping-check.sh defaults to /var/www/htnl/data/ip-results.json

## Installation

* cp ping-check.sh /path/bin/ping-check.sh for which every user you want running this
* create an ip-addr.txt like the file below
* add a cron entry with something like:
  */10 * * * * /path/bin/ping-check.sh && cp ip-results.json /path/www/data/ip-results.json && chmod a+r /path/www/data/ip-results.json

## ip-addr.txt

This file doesn't need to be neatly aligned. It just appeals to my anal coding nature that everything line up nice and pretty. I've tested with one of more spaces, tabs and a mix. All seem to work.

```
# Comments go here
# Fields are seperated with whitespace ("m using tabs here)
# Host_IP       Hostname        URL (can be relative or absolute)

Host_IP         Hostname        x/index.html
192.168.24.1    hostname1       a/index.html
192.168.24.2    hostname2       b/index.html
192.168.2.1     hostname3       c/index.html
failed.uucp     hostname4       d/index.html
```

## ip-results.json

Again, this file doesn't need to be neatly aligned. It just appeals to my anal coding nature that everything line up nice and pretty. This file just needs to be valid JSON. You can check that at: [JSON Parser Online Link](http://jsonparseronline.com/)

```
{
  "hosts": [
    { "name": "Hostname",  "ip": "Host_IP",      "state": "2", "href": "x/index.html" },
    { "name": "hostname1", "ip": "192.168.24.1", "state": "1", "href": "a/index.html" },
    { "name": "hostname2", "ip": "192.168.24.2", "state": "1", "href": "b/index.html" },
    { "name": "hostname3", "ip": "192.168.2.1",  "state": "0", "href": "c/index.html" },
    { "name": "hostname4", "ip": "failed.uucp",  "state": "2", "href": "d/index.html" }
  ],
  "script:": "ping-check.sh v1.2.3"
}
```
## ToDo

* Need to add the href support to the ping-check.sh
* Need to handle resizing of the web page (I'm not doing that now).
* More code clean up and refactoring.
* More comments to explain things better (the URL part can be confusing)
* Provide better git commit comments
* Wait for another feature request.