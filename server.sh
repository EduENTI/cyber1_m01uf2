#!/bin/bash

PORT=7777

echo "LSTP server (Lechuga Speaker Transfer Protocol)"

echo "0. LISTEN"

DATA=`nc -l $PORT`

PROTOCOL_PREFIX=`echo "$DATA" | cut -d " " -f 1`

echo "3. CHECK HEADER"

IP_CLIENT=`echo "$DATA" | cut -d " " -f 2`

if [ "$PROTOCOL_PREFIX" != "LSTP_1.1"  ]; then

	echo "ERROR 1: Header malformed. $DATA"

	echo "KO_HEADER" | nc $IP_CLIENT $PORT

	exit 1
fi

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

echo "15. LISTEN MD5"

DATA=`nc -l $PORT`

MD5_COMPROBAR=`cat server/$FILE_NAME | md5sum | cut -d " " -f 1`

echo "19. CHECK MD5"

if [ $DATA != $MD5_COMPROBAR  ]; then

	echo "KO_MD5" | nc $IP_CLIENT $PORT
	echo "ERROR 4: File data corrupted."
	echo "Original md5: $DATA"
	echo "Checked md5: $MD5_COMPROBAR"

fi

echo "20. SEND OK_MD5"

echo "OK_MD5" | nc $IP_CLIENT $PORT

echo "END"

exit 0
