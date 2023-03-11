#!/bin/bash

##################################################################################################################
# Name:                       check_architecture.sh
# Purpose:                    Returns boolean value depending on the architecture of the Mac. (ARM or x86_64)
#                             Returns 1 for x86_64, 0 for ARM 
###################################################################################################################

# Save processor 
processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

# Return integer
if [[ -n "$processor" ]]; then
    return 1
else
    return 0
fi