#!/bin/bash
#
# Credits to Gilbert Palau, Graham Pugh
# https://github.com/tempusthales/
#
# https://github.com/grahampugh/Rosetta-2-install
#

# Check to see if the Mac needs Rosetta installed based on processor string
processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

if [[ -n "$processor" ]]; then
  echo "$processor processor detected. Skipping Rosetta installation..."
  
  # Check for Rosetta "oahd" process. If not found,
  # perform a non-interactive install of Rosetta.
elif /usr/bin/pgrep oahd >/dev/null 2>&1 ; then
  echo "Rosetta is already installed. Skipping installation..."
else
  echo "Installing Rosetta..."
  #Install Rosetta
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        
    #checks for success of previous command
    if [[ $? -eq 0 ]]; then
      echo "Rosetta successfully installed."
      else
      echo "Rosetta installation failed!"
    fi
fi


# Possible feature inclusion?
#else
 # echo "Mac is running macOS $osvers_major.$osvers_minor.$osvers_dot_version."
  #echo "No need to install Rosetta on this version of macOS."
#fi
