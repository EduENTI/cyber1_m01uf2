#!/bin/bash

echo "LSTP server (Lechuga Speaker Transfer Protocol)"

echo "0. LISTEN"

DATA=`nc -l 7777`

echo "3. CHECK HEADER"

if [ "$DATA" != "LSTP_1"  ]; then

	echo "ERROR 1: Header malformed. $DATA"

	echo "KO_HEADER" | nc localhost 7777

	exit 1
fi

echo "4. SEND OK_HEADER"

echo "OK_HEADER" | nc localhost 7777

echo "5. LISTEN FILE_NAME"

DATA=`nc -l 7777`

FILE_NAME_PREFIX=`echo "$DATA" | cut -d " " -f 1`

echo "9. CHECK FILE_NAME"

if [ "$FILE_NAME_PREFIX" != "FILE_NAME"  ]; then
	
	echo "ERROR 3: Prefix unkown. $DATA"

	exit 1

fi
