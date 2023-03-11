#!/bin/bash

##################################################################################################################
# Name:                       check_architecture.sh
# Purpose:                    Returns boolean value depending on the architecture of the Mac. (ARM or x86_64)
#                             Returns 1 for x86_64, 0 for ARM 
###################################################################################################################

# Save processor 
processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

# Return 1 for x86_64, 0 for ARM 
if [[ -n "$processor" ]]; then
    exit 1
else
    exit 0
fi