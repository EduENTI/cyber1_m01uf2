#!/bin/bash

echo "LSTP Client (Lechuga Speaker Transfer Protocol)"

echo "1. SEND HEADER"

echo "LSTP_1" | nc localhost 7777

echo "2. LISTEN OK_HEADER"

DATA=`nc -l 7777`

echo "6. CHECK OK_HEADER"

if [ "$DATA" != "OK_HEADER"  ]; then

	echo "ERROR 2: Header not sent correctly. $DATA"

	exit 1
fi

#text2wave client/lechuga1.lechu -o client/lechuga1.wav

#ffmpeg -i client/lechuga1.wav client/lechuga1.ogg

echo "7. SEND FILE_NAME"

echo "FILE_NAME lechuga1.ogg" | nc localhost 7777

echo "8. LISTEN PREFIX_OK"
