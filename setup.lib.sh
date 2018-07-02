#!/bin/bash

# Init system. Sets the variable INIT_LIKE containing the most generic
# init system.
# Example: INIT_LIKE=systemd, or ID_LIKE=sysvinit
detectInitSystem() {
  which systemctl > /dev/null 2>&1
  if [ $? = 0 ]; then
    INIT_LIKE=systemd
    return
  fi
  which service > /dev/null 2>&1
  if [ $? = 0 ]; then
    INIT_LIKE=sysvinit
    return
  fi
  INIT_LIKE=""
}

# DO NOT CHANGE! This is needed to detect the init system.
detectInitSystem

# Start a service.
serviceStart() {
  local serviceName=$1
  if [ $INIT_LIKE = systemd ]; then
    systemctl enable $serviceName
    systemctl start $serviceName
    return $?
  fi
  if [ $INIT_LIKE = sysvinit ]; then
    service $serviceName start
    return $?
  fi
  return 0
}

# Stop a service.
serviceStop() {
  local serviceName=$1
  if [ $INIT_LIKE = systemd ]; then
    systemctl disable $serviceName
    systemctl stop $serviceName
    return $?
  fi
  if [ $INIT_LIKE = sysvinit ]; then
    service $serviceName stop
    return $?
  fi
  return 0
}

# Restart a service.
serviceRestart() {
  local serviceName=$1
  if [ $INIT_LIKE = systemd ]; then
    systemctl restart $serviceName
    return $?
  fi
  if [ $INIT_LIKE = sysvinit ]; then
    service $serviceName restart
    return $?
  fi
  return 0
}

# Query the status of a service.
serviceStatus() {
  local serviceName=$1
  if [ $INIT_LIKE = systemd ]; then
    systemctl status $serviceName
    return $?
  fi
  if [ $INIT_LIKE = sysvinit ]; then
    service $serviceName status
    return $?
  fi
  return 0
}

# Sets the variable ID_LIKE containing the most generic
# distribution name.
# Example: ID_LIKE=arch, or ID_LIKE=debian
detectLinuxDistribution() {
  eval `cat /etc/*-release | grep ID_LIKE` # debian, arch, ...
  eval `cat /etc/*-release | grep ID`      # ubuntu, raspbian, ...
  eval `cat /etc/*-release | grep VERSION` # Verbose ver. May contain substrings: wheezy, Xenial Xerus, Rolling ...
  # Fix missing $ID_LIKE variable. Use value from $ID instead.
  if [ -z $ID_LIKE ]; then
    ID_LIKE="$ID"
  fi
}

# DO NOT CHANGE! This is needed to detect the distribution name.
detectLinuxDistribution

# Arch Linux ARM only. Always use pacman.
pacman=pacman

# Query if a package is already installed.
packageQuery() {
  local packageName=$1
  if [ $ID_LIKE = arch ]; then
    $pacman -Qi $packageName > /dev/null
    return $?
  fi
  if [ $ID_LIKE = debian ]; then
    dpkg-query -l $packageName | grep "^ii" > /dev/null
    return $?
  fi
  return 0
}

# Update package databases and upgrade system.
packageUpdate() {
  if [ $ID_LIKE = arch ]; then
    $pacman --noconfirm -Syu
  fi
  if [ $ID_LIKE = debian ]; then
    apt-get update
    apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages upgrade
  fi
}

packageInstall() {
  local packageName=$1
  if [ $ID_LIKE = arch ]; then
    $pacman --noconfirm -S $packageName
    return $?
  fi
  if [ $ID_LIKE = debian ]; then
    apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -q=2 install $packageName
    return $?
  fi
}

packageUninstall() {
  local packageName=$1
  if [ $ID_LIKE = arch ]; then
    $pacman --noconfirm -R $packageName
    return $?
  fi
  if [ $ID_LIKE = debian ]; then
    apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -q=2 --purge autoremove $packageName
    return $?
  fi
}

packageCleanup() {
  if [ $ID_LIKE = arch ]; then
    $pacman --noconfirm -Scc
  fi
  if [ $ID_LIKE = debian ]; then
    apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -q=2 --purge autoremove
    apt-get --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages -q=2 clean
  fi
}

#Guess what?
runAsRoot() {
  sudo bash -c ". $BASH_SOURCE; $1 ${@: +2}"
}

# Raspbian Lite package mods.
_rpiModLitePackages() {
  local desktopPkg="raspberrypi-ui-mods"
  local developPkgs="
    git
    idle3
    python3-pip
    python3-pygame
    python3-gpiozero
    python3-rpi.gpio
    geany
    realvnc-vnc-server
    lxterminal
  "
  local uninstallPkgs="termit"
  runAsRoot packageUpdate
  runAsRoot packageInstall $desktopPkg
  for pkg in $developPkgs; do
    packageQuery $pkg
    if [ $? != 0 ]; then
      runAsRoot packageInstall $pkg
    fi
  done
  # Enable boot to desktop.
  sudo raspi-config nonint do_boot_behaviour B4
  # Enable VNC server.
  sudo raspi-config nonint do_vnc 0

  for pkg in $uninstallPkgs; do
    packageQuery $pkg
    if [ $? = 0 ]; then
      runAsRoot packageUninstall $pkg
    fi
  done
  runAsRoot packageCleanup
}

# Raspbian package mods.
rpiModPackages() {
  if [ $ID = raspbian ]; then
    # If we have no desktop environment then we are on Raspbian Lite.
    if [ ! -e /etc/init.d/lightdm ]; then
      _rpiModLitePackages
      return
    fi
  fi
  local uninstallPkgs="
    wolfram-engine
    bluej
    greenfoot
    nodered
    sonic-pi
    minecraft-pi
    python3-thonny
  "
  runAsRoot packageUpdate
  for pkg in $uninstallPkgs; do
    packageQuery $pkg
    if [ $? = 0 ]; then
      runAsRoot packageUninstall $pkg
    fi
  done
  local installPkgsDebian="zerofree"
  if [ $ID = debian ]; then
    for pkg in $installPkgsDebian; do
      packageQuery $pkg
      if [ $? != 0 ]; then
        runAsRoot packageInstall $pkg
      fi
    done
  fi
  runAsRoot packageCleanup
}

# Hide GRUB selection screen at desktop boot.
_setupGrubScreen() {
  sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
  chmod -x /etc/grub.d/05_debian_theme
  update-grub2
}

rpiSetupGrubScreen() {
  runAsRoot _setupGrubScreen
}

# Enable remote desktop access on raspbian.
rpiEnableVnc() {
  local vncPkg=realvnc-vnc-server
  local vncSrv=vncserver-x11-serviced
  packageQuery $vncPkg
  if [ $? != 0 ]; then
    runAsRoot packageInstall $vncPkg
  fi
  runAsRoot serviceStart $vncSrv
}

_setHdmiDmt1024x768() {
  sed -i 's/^#hdmi_force_hotplug=.*/hdmi_force_hotplug=1/' /boot/config.txt
  sed -i 's/^#hdmi_group=.*/hdmi_group=2/' /boot/config.txt
  sed -i 's/^#hdmi_mode=.*/hdmi_mode=16/' /boot/config.txt
}

rpiSetVideoMode() {
  runAsRoot _setHdmiDmt1024x768
}
