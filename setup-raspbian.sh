#!/bin/bash
source "$(dirname $0)/setup.lib.sh"

if [ $ID = raspbian ]; then
  rpiModPackages
  rpiEnableVnc
else
  echo "This script can run only on Raspbian operating system!"
fi

exit 0
