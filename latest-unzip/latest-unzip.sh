#!/bin/bash

################################################################################
# This script is licensed under the MIT License.                               #
#                                                                              #
# MIT License                                                                  #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a      #
# copy of this software and associated documentation files (the "Software"),   #
# to deal in the Software without restriction, including without limitation    #
# the rights to use, copy, modify, merge, publish, distribute, sublicense,     #
# and/or sell copies of the Software, and to permit persons to whom the        #
# Software is furnished to do so, subject to the following conditions:         #
#                                                                              #
# The above copyright notice and this permission notice shall be included      #
# in all copies or substantial portions of the Software.                       #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS      #
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL      #
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER   #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER          #
# DEALINGS IN THE SOFTWARE.                                                    #
################################################################################

##
# Detect
##

if command -v apt >/dev/null; then
  package_manager="apt"
elif command -v yum >/dev/null; then
  package_manager="yum"
else
  exit 1
fi

##
# Function
##

function version() {
  if [[ "$package_manager" == "apt" ]]; then
    version=$(apt-cache show $1 | grep Version | head -n 1 | awk '{print $2}')
  elif [[ "$package_manager" == "yum" ]]; then
    version=$(yum info $1 | grep Version | head -n 1 | awk '{print $3}')
  fi

  echo "$version"
}

function installer() {
  sudo $package_manager install -y $1
}

function executeInstaller() {
  get_version=$(version $1 2>/dev/null)

  while true; do
    echo -e "\n\033[0;37;0m[>] Do you want to install $1 $get_version? [y/n]\033[0m\c" && read -n 1 -s install
    if [[ "$install" == "y" ]]; then
        break
    elif [[ "$install" == "n" ]]; then
      exit 0
    else
      echo -e "\n\n\033[0;37;41m[x] Invalid input. Please enter 'y' or 'n'\033[0m"
    fi
  done
  
  echo -e "\n\n\033[0;37;43m[*] Installing $1\033[m\n" \
  && installer $1 \
  && echo -e "\n\033[0;37;42m[v] $1 is installed | PRESS ENTER TO CONTINUE\033[0m" && read -sp "" \
  || echo -e "\n\033[0;37;41m[x] $1 could not be installed | PRESS ENTER TO CONTINUE\033[0m" && read -sp ""
}

##
# Execute
##

executeInstaller "unzip"
