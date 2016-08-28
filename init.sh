#!/bin/bash
#
USER=$1
#
apt-get update && apt-get install -y dist-upgrade
apt-get install -y vim colordiff screen
adduser --disabled-password --gecos "${USER}" ${USER}
usermod -aG sudo ${USER}
mkdir /home/${USER}/.ssh/ && touch /home/${USER}/.ssh/authorized_keys
chown ${USER}:${USER} -R /home/${USER}/.ssh && chmod 700 /home/${USER}/.ssh && chmod 600 /home/${USER}/.ssh/authorized_keys
