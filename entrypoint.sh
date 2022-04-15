#!/bin/bash

KEY=$4
PORT=$2
USER=$3
HOST=$1
DIR=$5
VAULT=$6
PLAYBOOK=$7
TAGS=$8

# prepare ssh key
echo "$4" > id_rsa
chmod 600 id_rsa

echo "SSHing into host..."

ssh \
  -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFIle=/dev/null -i id_rsa -p $2 $3@$1 '
	echo "Connected to host."
	cd "'$DIR'"
	pwd

	if [[ "$(git pull)" != *"Already up to date."* ]]; then
		echo "Updated repo, cloning..."
		virtualenv -p /usr/bin/python3 .
		source bin/activate
		pip install -r ./requirements.txt
		ansible-galaxy install -r requirements.yml
	fi
	
	echo "Running playbook..."
	echo "'$VAULT'" > ./_vault_pass
	ansible-playbook -i hosts --vault-password-file ./_vault_pass "'$PLAYBOOK'" --tags "'$TAGS'"
'
