#!/bin/bash 
for userno in $(seq 1 $(cat /tmp/.TOR_COUNT));do 
   cport=2000$userno;
   printf 'AUTHENTICATE "'$(cat /dev/shm/.ctrlpsw)'"\r\nSIGNAL NEWNYM\r\n' | nc 127.0.0.1 2000$userno;
done
