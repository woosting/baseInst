#!/bin/bash
#
USER=$1
#
# UPDATE + UPGRADE
  apt-get update && apt-get install -y dist-upgrade
  apt-get install -y vim colordiff screen linuxlogo
# USER SPECIFICS
  adduser --disabled-password --gecos "${USER}" ${USER}
  usermod -aG sudo ${USER}
  mkdir /home/${USER}/.ssh/ && touch /home/${USER}/.ssh/authorized_keys
  chown ${USER}:${USER} -R /home/${USER}/.ssh && chmod 700 /home/${USER}/.ssh && chmod 600 /home/${USER}/.ssh/authorized_keys
  echo "" >> /home/${USER}/.bashrc
  echo "" >> /home/${USER}/.bashrc
  echo "###" >> /home/${USER}/.bashrc
  echo "# INIT.SH ADDITIONS" >> /home/${USER}/.bashrc
  echo "# Grouping directories first:" >> /home/${USER}/.bashrc
  echo "  ls='ls --color=auto --group-directories-first'" >> /home/${USER}/.bashrc
  echo "# Display logo at bash login:" >> /home/${USER}/.bashrc
  echo "  if [ -f /usr/bin/linux_logo ]; then linuxlogo -u -y; fi" >> /home/${USER}/.bashrc
  echo "" >> /home/${USER}/.bashrc
  echo "###" >> /home/${USER}/.bashrc
  echo "# MANUAL ADDITIONS" >> /home/${USER}/.bashrc
