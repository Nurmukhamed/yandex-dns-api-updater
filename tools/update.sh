#!/bin/bash

usage() { echo "Usage: $0 [-a token] [-b domain] [-t ttl] [-r record] [-d subdomain] [-i ipaddress]" 1>&2; exit 1; }

while getopts ":a:b:t:r:d:i:h:" arg; do
	case $arg in
		a)
		token=${OPTARG}	
		;;
		b)
		domain=${OPTARG}
		;;
		t)
		ttl=${OPTARG}
		;;
		r)
		record=${OPTARG}
		;;
		d)
		subdomain=${OPTARG}
		;;
		i)
		ipaddress=${OPTARG}
		;;
		h)
		usage
		exit 1;
		;;
	esac
done

if [ -n "${token}" ]; then
	usage
	exit 0
fi
if [ -n "${domain}" ]; then
	usage
	exit 0
fi
if [ -n "${ttl}" ]; then
	usage
	exit 0
fi
if [ -n "${record}" ]; then
	usage
	exit 0
fi
if [ -n "${subdomain}" ]; then
	usage
	exit 0
fi
if [ -n "${ipaddress}" ]; then
	usage
	exit 0
fi

api_url="https://pddimp.yandex.ru/api2"
curl --silent -H 'PddToken: '$token'' -d 'domain='${domain}'&record_id='${record}'&subdomain='${subdomain}'&ttl='$ttl'&content='${ipaddress}'' ${api_url}/admin/dns/edit
