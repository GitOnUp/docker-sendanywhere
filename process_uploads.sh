#!/bin/bash
FILES=/home/ubuntu/Downloads/*
#FILES=/home/george/src/docker-ubuntu-vnc-desktop/test/*
TARGETWIDTH=1024
ALLROOT=/home/ubuntu/all_uploads
#ALLROOT=/home/george/src/docker-ubuntu-vnc-desktop/test-all
WEBROOT=/home/ubuntu/web_uploads
#WEBROOT=/home/george/src/docker-ubuntu-vnc-desktop/test-web
for FILE in $FILES
do
	if [ -f "$FILE" ]; then
		BASEFILE=`basename "$FILE"`
		if echo "$FILE" | grep -e '.sendanywhere$' > /dev/null; then
			echo "skipping in-progress file: $FILE"
		elif identify "$FILE" > /dev/null; then
			echo "converting image file for web: $FILE"
			WIDTH=`identify -format '%w' "$FILE"`
			TRANSFORM="-strip"
			if [[ `echo "$WIDTH > $TARGETWIDTH" | bc` -eq '1' ]]; then
				FACTOR=`echo "($TARGETWIDTH * 100) / $WIDTH" | bc`
				TRANSFORM="$TRANSFORM -resize $FACTOR%"
			fi
			case `identify -format '%[exif:Orientation]' "$FILE"` in
			1) TRANSFORM="$TRANSFORM";;
			2) TRANSFORM="$TRANSFORM -flop";;
			3) TRANSFORM="$TRANSFORM -rotate 180";;
			4) TRANSFORM="$TRANSFORM -flip";;
			5) TRANSFORM="$TRANSFORM -transpose";;
			6) TRANSFORM="$TRANSFORM -rotate 90";;
			7) TRANSFORM="$TRANSFORM -transverse";;
			8) TRANSFORM="$TRANSFORM -rotate 270";;
			*) TRANSFORM="$TRANSFORM";;
			esac
			convert "$FILE" $TRANSFORM "$WEBROOT/$BASEFILE"
			mv "$FILE" "$ALLROOT/$BASEFILE"
		else
			mv "$FILE" "$ALLROOT/$BASEFILE"
		fi
	else
		echo "Ignoring non-regular-file $FILE"
	fi
done
