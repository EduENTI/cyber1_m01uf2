#!/bin/bash

PORT=7777

IP_SERVER="localhost"

FILE="saludo.ogg"

IP_CLIENT=`ip a | grep "inet " | grep brd | cut -d " " -f 6 | cut -d "/" -f 1`

echo "LSTP Client (Lechuga Speaker Transfer Protocol)"

echo "1. SEND HEADER"

echo "LSTP_1.1 $IP_CLIENT" | nc $IP_SERVER $PORT

echo "2. LISTEN OK_HEADER"

DATA=`nc -l $PORT`

echo "6. CHECK OK_HEADER"

if [ "$DATA" != "OK_HEADER"  ]; then

	echo "ERROR 1: Header not sent correctly. $DATA"

	exit 1
fi

#text2wave client/lechuga1.lechu -o client/lechuga1.wav

#ffmpeg -i client/lechuga1.wav client/lechuga1.ogg

echo "7. SEND FILE_NAME"

echo "FILE_NAME saludo.ogg" | nc $IP_SERVER $PORT

echo "8. LISTEN PREFIX_OK"

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]; then
	
	echo "ERROR 2: Filename not set correctly. $DATA"

	exit 2

fi

echo "12. SEND FILE_DATA"

cat "$FILE" | nc $IP_SERVER $PORT

echo "13. LISTEN OK_FILE_DATA"

DATA=`nc -l $PORT`
