#!/bin/bash

USER=$1
TODAY=$(date +%Y%m%d)

while getopts d option
  do
    case "${option}"
     in
      d) DENV="lxde";;
      #x) EXAMPLE=(${OPTARG});;
    esac
  done

if [ ! ${USER} ]; then
      echo -e "Usage: init username [-d lxde]"
      echo -e "       -d Set desktop environment to: LXDE"
      exit 1;
  else
    # UPDATE + UPGRADE + INSTALLS
      apt-get update && apt-get install -y dist-upgrade
      apt-get install -y vim colordiff screen
      #apt-get install -y linuxlogo
    # USER ADDITION
      adduser --disabled-password --gecos "${USER}" ${USER}
      usermod -aG sudo ${USER}
      mkdir /home/${USER}/.ssh/ && touch /home/${USER}/.ssh/authorized_keys
      chown ${USER}:${USER} -R /home/${USER}/.ssh && chmod 700 /home/${USER}/.ssh && chmod 600 /home/${USER}/.ssh/authorized_keys
    # CUSTOM SCRIPTS
      mkdir /home/${USER}/scripts
      wget -P /home/${USER}/scripts https://raw.githubusercontent.com/woosting/dirp/master/dirp.sh && \
        ln -s /home/${USER}/scripts/dirp.sh /usr/local/bin/dirp
      wget -P /home/${USER}/scripts https://raw.githubusercontent.com/woosting/stba/master/stba.sh && \
        ln -s /home/${USER}/scripts/stba.sh /usr/local/bin/stba
      chown ${USER}:${USER} -R /home/${USER}/scripts
      chmod 755 /home/${USER}/scripts/*.sh
    # UX
      cp /home/${USER}/.bashrc /home/${USER}/.bashrc.bak${TODAY}
      echo "" >> /home/${USER}/.bashrc
      echo "###" >> /home/${USER}/.bashrc
      echo "# INIT.SH ADDITIONS" >> /home/${USER}/.bashrc
      echo "# Things automatically added by the init.sh script:" >> /home/${USER}/.bashrc
      echo "# Grouping directories first:" >> /home/${USER}/.bashrc
      echo "alias ls='ls --color=auto --group-directories-first'" >> /home/${USER}/.bashrc
      echo "alias weather='wget -qO- wttr.in'" >> /home/${USER}/.bashrc
      echo "alias cpuhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head && uptime'" >> /home/${USER}/.bashrc
      echo "alias memhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head'" >> /home/${USER}/.bashrc
      echo "" >> /home/${USER}/.bashrc
      echo "###" >> /home/${USER}/.bashrc
      echo "# MANUAL ADDITIONS" >> /home/${USER}/.bashrc
      echo "# Add your own:" >> /home/${USER}/.bashrc
      echo "" >> /home/${USER}/.bashrc
      echo "###" >> /home/${USER}/.bashrc
      echo "# LAST TO EXECUTE" >> /home/${USER}/.bashrc
      echo "# Things to run at the end of .bashrc loading:" >> /home/${USER}/.bashrc
      echo "# Display logo at bash login:" >> /home/${USER}/.bashrc
      echo "#if [ -f /usr/bin/linux_logo ]; then linuxlogo -u -y; fi" >> /home/${USER}/.bashrc
    if [ ${DENV} ]; then
      mkdir /home/${USER}/Downloads/${DENV}
      mkdir /home/${USER}/Downloads/${DENV}/openbox && wget -P /home/${USER}/Downloads/${DENV}/openbox https://dl.opendesktop.org/api/files/download/id/1460769323/69196-1977-openbox.obt
      mkdir /home/${USER}/Downloads/${DENV}/icons && wget -P /home/${USER}/Downloads/${DENV}/icons https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/faenza-icon-theme/faenza-icon-theme_1.3.zip
    fi
fi
