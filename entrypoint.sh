#!/bin/sh

KEY_FILE_PATH=/etc/ssh/ssh_host_rsa_key

if [ -e "${KEY_FILE_PATH}" ]; then
	echo "Use existing host key"
	true
elif [ -n "${HOST_RSA_KEY}" ]; then
	echo "Use host key from env"
	echo "${HOST_RSA_KEY}" > ${KEY_FILE_PATH}
	chmod 0600 ${KEY_FILE_PATH}
else
	echo "Generate new host key"
	ssh-keygen -P "" -t rsa -f ${KEY_FILE_PATH}
	chmod 0600 ${KEY_FILE_PATH}
fi

FINGERPRINT=$(ssh-keygen -l -f ${KEY_FILE_PATH} | grep -o -E "[^: ]{43}")
echo "Fingerprint: ${FINGERPRINT}"

/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config -d
