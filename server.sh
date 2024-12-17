#!/bin/bash

PORT=7777

echo "LSTP server (Lechuga Speaker Transfer Protocol)"

echo "0. LISTEN"

DATA=`nc -l $PORT`

PROTOCOL_PREFIX=`echo "$DATA" | cut -d " " -f 1`

echo "3. CHECK HEADER"

if [ "$PROTOCOL_PREFIX" != "LSTP_1.1"  ]; then

	echo "ERROR 1: Header malformed. $DATA"

	echo "KO_HEADER" | nc $IP_CLIENT $PORT

	exit 1
fi

IP_CLIENT=`echo "$DATA" | cut -d " " -f 2`

echo "4. SEND OK_HEADER"

echo "OK_HEADER" | nc $IP_CLIENT $PORT

echo "5. LISTEN FILE_NAME"

DATA=`nc -l $PORT`

FILE_NAME_PREFIX=`echo "$DATA" | cut -d " " -f 1`

echo "9. CHECK FILE_NAME"

if [ "$FILE_NAME_PREFIX" != "FILE_NAME"  ]; then
	
	echo "ERROR 2: Prefix unkown. $DATA"

	echo "KO_FILE_NAME"
	
	exit 2

fi

FILE_NAME=`echo "$DATA" | cut -d " " -f 2`

echo "10. SEND OK_FILE_NAME"

echo "OK_FILE_NAME" | nc $IP_CLIENT $PORT

echo "11. LISTEN FILE_DATA"

nc -l $PORT > server/$FILE_NAME

echo "14. SEND OK_FILE_DATA"

FILE_SIZE=`ls -l server/$FILE_NAME | cut -d " " -f 5`

if [ $FILE_SIZE == 0 ]; then

	echo "ERROR 3: No file data. File size: $FILE_SIZE B."

	echo "KO_FILE_DATA"

	exit 3

fi
 echo "OK_FILE_DATA" | nc $IP_CLIENT $PORT
