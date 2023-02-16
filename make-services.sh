#!/bin/sh
rm -rf services
[[ -z "$TORINSTANCECOUNT" ]] && TORINSTANCECOUNT=8

for N in $(seq 1 $TORINSTANCECOUNT)
do
	mkdir -p /services/tor$N
	SVFILE=/services/tor$N/run
	(echo '#!/bin/sh'  
	echo "mkdir -p /tmp/.var_lib_tor/$N" 
	echo "chmod a+rw /tmp/.var_lib_tor/$N"
	echo "chmod a+rx /tmp/.var_lib_tor"
	echo "exec tor --SocksPort 905$N --PidFile /var/run/tor.$N.pid --CookieAuthentication 1 --Sandbox 0 --DataDirectory /tmp/.var_lib_tor/$N" ) > $SVFILE
	
	

	chmod 755 $SVFILE
done

mkdir -p /services/haproxy
SVFILE=/services/haproxy/run
echo '#!/bin/sh' > $SVFILE
echo 'exec haproxy -f /etc/haproxy/haproxy.cfg' >> $SVFILE 
chmod 755 $SVFILE
