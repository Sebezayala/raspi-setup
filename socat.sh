#!/bin/bash
x=5
while true
do
	/usr/bin/socat -u TCP:localhost:30005 TCP:18.216.189.229:30004
	sleep $x
	if [ $x -lt 60 ]
	then
		x=$[$x+5]
	fi
done
