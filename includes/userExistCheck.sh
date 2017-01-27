#!/bin/bash
#
# # User existance check (userExistcheck)
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


function printHelp () {
  echo -e "USEREXISTCHECK - User existance check (2016, GNU GENERAL PUBLIC LICENSE)\n"
  echo -e "USAGE: userExistCheck username\n"
} 

USER2CHECK=$1

if [ ! ${USER2CHECK} ]; then
  printHelp
  echo -e "Please provide a username to check for!"
  exit 1;
else
  if id "${USER2CHECK}" >/dev/null 2>&1; then
    echo "Yes, ${USER2CHECK} exists!"
  else
    echo "No, ${USER2CHECK} does not exist!"
  fi
fi
