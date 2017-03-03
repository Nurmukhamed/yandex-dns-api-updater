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
	echo "${filename}"
	echo 
	ipaddress=$(cat ${filename})
	echo "${ipaddress}"
	echo 

	commit=$(git log --format="%H" -n 1)
	echo $commit
	echo
	
	if [ -n "${commit}" ]; then
		file_in_commit=$(git diff-tree --no-commit-id --name-only -r ${commit}|grep ${filename})
		echo "${file_in_commit}"
		echo 

		if [ -n "${file_in_commit}" ]; then
			gpgsign=$(git show --show-signature ${commit} | grep ${gpgkey})
			
			echo ${gpgsign}
			echo
		
			if [ -n "${gpgsign}" ]; then
				echo "Update Yandex DNA API"
		
				echo "./tools/update.sh -a ${token} -b ${dnsdomain} -t ${ttl} -r ${record} -d ${subdomain} -i ${ipaddress}"
				./tools/update.sh -a ${token} -b ${dnsdomain} -t ${ttl} -r ${record} -d ${subdomain} -i ${ipaddress}
			else
				echo "Found that file ${filename} signed by other gpg-key"
			fi
		else
			echo "File ${filename} is not found in commit ${commit}"
		fi
	else
		echo "No commits were found\n"
	fi
done
