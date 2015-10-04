#!/bin/bash
set -x

#UPDATES MY OWN DNS SERVER
echo $IS_KUBE
if [ "$IS_KUBE" ]; then
    echo "Updating DNS record"        
    ipaddr=$(hostname -i)
    curl -X PATCH -d '{"'$INSTANCE'":"'$ipaddr'"}' \
          $DNS_ADDR'/dns.json'
fi

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

#WAIT FOR THE REDIS SERVER TO BOOT
#sleep 30

exec "$@"
