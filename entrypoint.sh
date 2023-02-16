#!/bin/sh

phrase=$RANDOM"_asd_"$RANDOM"_wsx_"$RANDOM

echo "$phrase" > /dev/shm/.ctrlpsw
[[ -z "$TORCOUNT" ]] && TORCOUNT=6
echo $TORCOUNT > /tmp/.TOR_COUNT

pswhash=$(tor  --hash-password  "$phrase"|grep -v "You are running Tor as ro") 2>/dev/null
echo -n "$pswhash" > /tmp/.pswhash

echo "control pass is $pswhash (hashed)"
[[ "$USE_AVAHI" = "true" ]] && ( 
    while (true);do
        dbus-daemon --nofork --config-file=/usr/share/dbus-1/system.conf  2>&1 |sed 's/^/  DBUS:/g' & sleep 10
        ps -A|grep dbus ;
        avahi-daemon -f /avahi.conf  2>&1 |sed 's/^/AVAHI:/g' |grep -v -e "Successfully dropped root privileges" -e "starting up" -e "consider installing nss-mdns" -e "AVAHI:Found user"; 
        kill -9 $(pidof dbus-daemon avahi-daemon ); 
        sleep 10;
        kill -9 $(pidof dbus-daemon avahi-daemon ) 2>/dev/null ; 
        
        done  
   ) &


env > /etc/envvars
echo "Running Runit"
#exec /sbin/runsvdir -P /etc/sv
exec /sbin/runsvdir -P /services
echo "Failed!"
