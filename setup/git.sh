#!/bin/bash

if ! type "xclip" > /dev/null; then
	sudo apt-get install -y xclip
fi

if [ -z "$1"  ]; then
	echo "Please provide your email as an argument to the script"
	exit 1
fi

SSH_DIRECTORY=~/.ssh

if [ ! -d "$SSH_DIRECTORY" ]; then
	mkdir $SSH_DIRECTORY
else
	if [ -f "$SSH_DIRECTORY/id_rsa" ]; then
		echo "id_rsa key exists. Please backup or rename"
		exit 2
	fi
fi

pushd .
cd $SSH_DIRECTORY

ssh-keygen -t rsa -b 4096 -C "$1"

popd

xclip -sel clip < ~/.ssh/id_rsa.pub

echo "Public key successfully created and copied to clipboard."
echo "Please paste the key into github."

read -n1 -r -p "Press any key to continue and test key..." key

ssh -T git@github.com
