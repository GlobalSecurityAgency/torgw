#!/bin/sh
rm -rf services
[[ -z "$TORINSTANCECOUNT" ]] && TORINSTANCECOUNT=8

sed 's/^Log.\+//g' /etc/tor/torrc -i 
(
    echo "WarnUnsafeSocks 0"
    echo "WarnPlaintextPorts 1"
    echo "Log warn-err stderr" )>> /etc/tor/torrc


for N in $(seq 1 $TORINSTANCECOUNT)
do
    userno=$N
	mkdir -p /services/tor$N
	SVFILE=/services/tor$N/run
	(echo '#!/bin/sh'
	echo 'pswhash=$(cat /tmp/.pswhash)'  
	echo "mkdir -p /tmp/.var_lib_tor/$N" 
	echo "chmod a+rw /tmp/.var_lib_tor/$N"
	echo "chmod a+rx /tmp/.var_lib_tor"
	#echo "cp /etc/tor/torrc /tmp/.var_lib_tor/$N/"
	echo '(echo "WarnUnsafeSocks 0";echo "WarnPlaintextPorts 1";echo "Log warn-err stderr";echo "DataDirectory /tmp/.var_lib_tor/"'$userno';echo "ControlPort 2000'$userno'";echo "SOCKSPort 905'$userno'";echo "HashedControlPassword "$pswhash)|'"exec tor -f /dev/stdin --SocksPort 905$N --PidFile /var/run/tor.$N.pid --CookieAuthentication 1 --Sandbox 0 --DataDirectory /tmp/.var_lib_tor/$N" 
	) > $SVFILE

	
	

	chmod 755 $SVFILE
done

mkdir -p /services/haproxy
SVFILE=/services/haproxy/run
echo '#!/bin/sh' > $SVFILE
echo 'exec haproxy -f /etc/haproxy/haproxy.cfg' >> $SVFILE 
chmod 755 $SVFILE
