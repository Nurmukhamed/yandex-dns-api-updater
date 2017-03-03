#!/bin/bash

# check git status
for line in $(cat data.txt); do
	token=$(echo ${line}|cut -d ":" -f 1)
	dnsdomain=$(echo ${line}|cut -d ":" -f 2)
	ttl=$(echo ${line}|cut -d ":" -f 3)
	record=$(echo ${line}|cut -d ":" -f 5)
	subdomain=$(echo ${line}|cut -d ":" -f 4)
	gpgkey=$(echo ${line}|cut -d ":" -f 6)
	filename="${subdomain}.txt"

	commit=$(git log --all -- '${filename}' | grep "commit" | head -n 1 | awk '{print $2}' )
	echo $commit
	echo
	if [ -n "${commit}" ]; then
		gpgsign=$(git log --show-signature ${commit} | grep ${gpgkey} | head -n 1)
		echo ${gpgsign}
		echo
		if [ -n "${gpgsign}" ]; then
			echo "Update Yandex DNA API"
			ipaddress=$(cat ${filename})
			$HOME/tools/update.sh -a ${token} -b ${dnsdomain} -t ${ttl} -r ${record} -d ${subdomain} -i ${ipaddress}
		else
			echo "Found that file ${filename} signed by other gpg-key"
		fi
	else
		echo "No commits were found\n"
	fi
done
