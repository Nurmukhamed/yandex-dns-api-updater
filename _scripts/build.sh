#!/bin/bash

# check git status

for file in $(git status --porcelain); do
gpgkey=$(cat links.txt|grep ${file}| cut -d ":" -f 2)

if [ -n "${gpgkey}" ]; then
	commit=$(git log --all -- '${file}' | grep "commit" | head -n 1| awk '{print $2}')
	
	if [ -n "${commit}"]; then
		gpgsign=$(git log --show-signature ${commit} | grep ${gpgkey}| head -n 1)

		if [ -n "${gpgsign}" ]; then
			echo "Update Yandex DNA API"
			dnsname="$(echo ${file}| cut -d "." -f 1).homeserver.kz"
			ipaddress=$(cat $file)
			dnsdomain="homeserver.kz"
			ttl="900"
			token="$(cat data.txt|grep ${name}|cut -d ":" -f 1)"
			record="$(cat data.txt|grep ${name}|cut -d ":" -f 5)"
			echo "DNSRECORD is ${dnsrecord}"
			echo "IPAddress is ${ipaddress}"
			$HOME/tools/update.sh -a ${token} -b ${dnsdomain} -t ${ttl} -r ${record} -d ${dnsname} -i ${ipaddress}
		else
			echo "Found that file ${file} signed by other gpg-key"
		fi
	else
		echo "No commits were found\n"
	fi
else
	echo "Found file ${file} that do not have corresponding gpg-key"
fi


done
