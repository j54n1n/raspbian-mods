#!/bin/bash
source "$(dirname $0)/setup.lib.sh"

if [ $ID = debian ]; then
  rpiModPackages
  rpiSetupGrubScreen
  chmod +x "$(dirname $0)/prepare-vbox-appliance"
  sudo cp "$(dirname $0)/prepare-vbox-appliance" /usr/local/bin/
else
  echo "This script can run only on Raspberry Pi Desktop operating system!"
fi

exit 0
