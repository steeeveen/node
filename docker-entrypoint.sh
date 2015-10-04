#!/bin/bash
set -x

while [ "$redisActive" != "true" ]
do
    dnsrecords=$(curl $DNS_ADDR'/dns.json')
    dnsrecords="${dnsrecords:1:${#dnsrecords}-2}"
    echo $dnsrecords

    #EXPORTS DNS SERVER ADDRESSES AS IP
    IFS=',' read -a array <<< "$dnsrecords"
    for element in "${array[@]}"
    do
        element=${element/:/=}
        setenv="export $element"
        eval $setenv
    done
    sleep 5
done

exec "$@"
