#!/bin/bash
#
# # Base Install (baseInst)
#
# Copyright 2016 Willem Oosting
#
# >This program is free software: you can redistribute it and/or modify
# >it under the terms of the GNU General Public License as published by
# >the Free Software Foundation, either version 3 of the License, or
# >(at your option) any later version.
# >
# >This program is distributed in the hope that it will be useful,
# >but WITHOUT ANY WARRANTY; without even the implied warranty of
# >MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# >GNU General Public License for more details.
# >
# >You should have received a copy of the GNU General Public License
# >along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# FORK ME AT GITHUB: https://github.com/woosting/baseInst


# INITIALISATION

  TODAY=$(date +%Y%m%d)
  NEWUSER=""
  while getopts u:dh option
    do
      case "${option}"
       in
        u) NEWUSER=(${OPTARG});;
        d) DENV="lxde";;
        h) 
          printHelp
          exit 0
        #x) EXAMPLE=(${OPTARG});;
      esac
    done
 
 
# FUNCTION DEFINITION

  function printHelp () {
    echo -e "BASEINST - Base installation (2016, GNU GENERAL PUBLIC LICENSE)\n"
    echo -e "USAGE: init [-d] -u username\n"
    echo -e "Arguments:\n"
    echo -e "       -u Creates the user (REQUIRED)"
    echo -e "       -d Sets desktop environment to: LXDE (OPTIONAL)"
}    


# LOGIC
  if [ ! ${NEWUSER} ]; then
    printHelp
    exit 1;
  else
  # UPDATE + UPGRADE + INSTALLS
    apt-get update && apt-get -y dist-upgrade
    apt-get install -y ssh vim screen wget git fail2ban colordiff
    #apt-get install -y linuxlogo cmatrix sl mplayer
  # USER ADDITION
    adduser --disabled-password --gecos "${NEWUSER}" ${NEWUSER}
    usermod -aG sudo ${NEWUSER}
    mkdir /home/${NEWUSER}/.ssh/ && touch /home/${NEWUSER}/.ssh/authorized_keys
    chown ${NEWUSER}:${NEWUSER} -R /home/${NEWUSER}/.ssh && chmod 700 /home/${NEWUSER}/.ssh && chmod 600 /home/${NEWUSER}/.ssh/authorized_keys
  # CUSTOM SCRIPT DOWNLOADS
    mkdir /home/${NEWUSER}/scripts
    git clone https://github.com/woosting/dirp.git /home/${NEWUSER}/scripts/dirp && \
      ln -s /home/${NEWUSER}/scripts/dirp/dirp.sh /usr/local/bin/dirp
    git clone https://github.com/woosting/stba.git /home/${NEWUSER}/scripts/stba && \
      ln -s /home/${NEWUSER}/scripts/stba/stba.sh /usr/local/bin/stba
    chown ${NEWUSER}:${NEWUSER} -R /home/${NEWUSER}/scripts
    chmod 755 /home/${NEWUSER}/scripts/*/*.sh
  # USER CONFIG
    # VIM
      wget -P /home/${NEWUSER}/ https://raw.githubusercontent.com/woosting/baseInst/master/configs/.vimrc && \
      chown ${NEWUSER}:${NEWUSER} /home/${NEWUSER}/.vimrc
    # BASH
      cp /home/${NEWUSER}/.bashrc /home/${NEWUSER}/.bashrc.bak${TODAY} && chown ${NEWUSER}:${NEWUSER} /home/${NEWUSER}/.bashrc.bak${TODAY}
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# INIT.SH ADDITIONS" >> /home/${NEWUSER}/.bashrc
      echo "# Things automatically added by woosting's init.sh script:" >> /home/${NEWUSER}/.bashrc
      echo "#" >> /home/${NEWUSER}/.bashrc
    
      # Git prompt
        apt-get install -y bash-completion && \
        sed -i '/\\w\\\[\\033\[00m\\\]\\\$/i \ \ \ \ export GIT_PS1_SHOWDIRTYSTATE=1' /home/${NEWUSER}/.bashrc && \
        sed -i 's/\\w\\\[\\033\[00m\\\]\\\$/\\w\\[\\033[36m\\]$(__git_ps1)\\033[00m\\]\\$/g' /home/${NEWUSER}/.bashrc && \
        echo "# GIT/Bash completion" >> /home/${NEWUSER}/.bashrc && \
        echo "  if [ -f /etc/bash_completion ]; then" >> /home/${NEWUSER}/.bashrc && \
        echo "    . /etc/bash_completion" >> /home/${NEWUSER}/.bashrc && \
        echo "  fi" >> /home/${NEWUSER}/.bashrc

      echo "# Aliasses" >> /home/${NEWUSER}/.bashrc
      echo "  alias ls='ls --color=auto --group-directories-first'" >> /home/${NEWUSER}/.bashrc
      echo "  alias grep='grep --color=auto'" >> /home/${NEWUSER}/.bashrc
      echo "  alias fgrep='fgrep --color=auto'" >> /home/${NEWUSER}/.bashrc
      echo "  alias egrep='egrep --color=auto'" >> /home/${NEWUSER}/.bashrc
      echo "  alias weather='wget -qO- wttr.in'" >> /home/${NEWUSER}/.bashrc
      echo "  alias cpuhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head && uptime'" >> /home/${NEWUSER}/.bashrc
      echo "  alias memhoggers='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head'" >> /home/${NEWUSER}/.bashrc
      
      echo "# Others" >> /home/${NEWUSER}/.bashrc
      echo "  export EDITOR=vim" >> /home/${NEWUSER}/.bashrc
      
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# MANUAL ADDITIONS" >> /home/${NEWUSER}/.bashrc
      echo "# Add your own:" >> /home/${NEWUSER}/.bashrc
      echo "" >> /home/${NEWUSER}/.bashrc
      echo "###" >> /home/${NEWUSER}/.bashrc
      echo "# LAST TO EXECUTE" >> /home/${NEWUSER}/.bashrc
      echo "# Things to run at the end of .bashrc loading:" >> /home/${NEWUSER}/.bashrc
      echo "# Display logo at bash login:" >> /home/${NEWUSER}/.bashrc
      echo "#if [ -f /usr/bin/linux_logo ]; then linuxlogo -u -y; fi" >> /home/${NEWUSER}/.bashrc
  # DESKTOP TWEAKING
    if [ ${DENV} ]; then
      mkdir /home/${NEWUSER}/Downloads && \
      mkdir /home/${NEWUSER}/Downloads/${DENV} && \
      mkdir /home/${NEWUSER}/Downloads/${DENV}/openbox && wget -P /home/${NEWUSER}/Downloads/${DENV}/openbox https://dl.opendesktop.org/api/files/download/id/1460769323/69196-1977-openbox.obt
      mkdir /home/${NEWUSER}/Downloads/${DENV}/icons && wget -P /home/${NEWUSER}/Downloads/${DENV}/icons https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/faenza-icon-theme/faenza-icon-theme_1.3.zip
    fi
fi
