#!/bin/bash
source "$(dirname $0)/setup.lib.sh"

if [ $ID = debian ]; then
  rpiModPackages
  sudo apt-get autoremove
  rpiHideGrubScreen
else
  echo "This script can run only on Raspberry Pi Desktop operating system!"
fi

exit 0
