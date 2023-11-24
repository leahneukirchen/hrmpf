#!/bin/sh

FILE=$1
DATE=${FILE##*-}
DATE=${DATE%.iso}

mktorrent -l 19 \
	-a "udp://tracker.openbittorrent.com:6969" \
	-c "hrmpf v$DATE - https://github.com/leahneukirchen/hrmpf" \
	-w "https://github.com/leahneukirchen/hrmpf/releases/download/v$DATE/$FILE" \
        $FILE
