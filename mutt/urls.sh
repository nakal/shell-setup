#!/bin/sh

# This script is a small hack for urlview that helps with BASE64 emails.

headers=1
base64=0
TMPFILE=`mktemp -t mailurls`
TMPFILE2=`mktemp -t mailurls`
while [ $headers -eq 1 ]; do
	read ln
	if echo $ln | grep -qEi '^Content-Transfer-Encoding:.*base64'; then
		base64=1
	fi
	if [ -z "$ln" ]; then
		headers=0
	fi
done
cat > "$TMPFILE"

if [ $base64 -eq 1 ]; then
	openssl base64 -d < "$TMPFILE" > "$TMPFILE2"
	cat "$TMPFILE" >> "$TMPFILE2"
	rm -f "$TMPFILE"
else
	mv "$TMPFILE" "$TMPFILE2"
fi

cat "$TMPFILE2" | urlview

exit 0
