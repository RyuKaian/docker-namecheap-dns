#!/usr/bin/with-contenv bash

. /app/namecheap.conf
RESPONSE=`curl -s "https://dynamicdns.park-your-domain.com/update?host=$HOSTS&domain=$DOMAIN&password=$TOKEN"`

echo "$RESPONSE "$(date)
