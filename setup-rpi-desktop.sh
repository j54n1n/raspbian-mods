#!/bin/bash
source "$(dirname $0)/setup.lib.sh"

if [ $ID = debian ]; then
  rpiModPackages
  rpiSetupGrubScreen
  chmod +x "$(dirname $0)/prepare-vbox-appliance"
  chmod +x "$(dirname $0)/prepare-rpi-image"
  sudo cp "$(dirname $0)/prepare-vbox-appliance" /usr/local/bin/
  sudo cp "$(dirname $0)/prepare-rpi-image" /usr/local/bin/
  curl https://raw.githubusercontent.com/Drewsif/PiShrink/63b7509ade7d2fb518536abd3c0d0eca43774b98/pishrink.sh
  sudo cp pishrink.sh /usr/local/bin
  rm pishrink.sh
else
  echo "This script can run only on Raspberry Pi Desktop operating system!"
fi

exit 0
