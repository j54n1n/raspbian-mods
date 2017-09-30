# Raspbian Mods
Scripts for customizing [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)
and [Raspberry Pi Desktop](https://www.raspberrypi.org/downloads/raspberry-pi-desktop/)
images. For further technical details please see the
[wiki pages](https://github.com/j54n1n/raspbian-mods/wiki).

## Setup Raspbian with Desktop Environment
**How to install Raspbian on the Raspberry Pi?**
Simply [grab the latest release](https://github.com/j54n1n/raspbian-mods/releases/latest)
and download the ZIP file containing the Raspbian image. Extract the IMG file and
[copy it over to a suitable SD card](https://www.raspberrypi.org/documentation/installation/installing-images/)
using the [Etcher tool](https://etcher.io/). Then insert the SD card in to the
Raspberry Pi. Be patient as the first time start process may take some time until
it has fully configured the Raspberry Pi.

See also the article on
[how the Raspbian image was created](https://github.com/j54n1n/raspbian-mods/wiki/Raspbian-Image-Creation).

## Setup Raspberry Pi Desktop with VirtualBox
**You do not own an Raspberry Pi but wish to try out an Raspbian like operating system?**
Simply [grab the latest release](https://github.com/j54n1n/raspbian-mods/releases/latest)
and download the VirtualBox Appliance file and
[import it to VirtualBox](https://www.virtualbox.org/manual/UserManual.html#ovf).

**You do not know what is VirtualBox?**
Do not worry VirtualBox allows you to create a second virtual PC within your current
operating system. Simply grab the
[latest release for your system](https://www.virtualbox.org/wiki/Downloads) and download both
the *platform package* and *extension pack*. Install first the platform package and then apply
the extension pack by double clicking it. Furthermore make sure that your computer has enabled
[hardware virtualization technology](https://amiduos.com/support/knowledge-base/article/enabling-virtualization-technology-in-hp-systems).
Now you are ready to create and import virtual machines. 

See also the article on
[how the VirtualBox Appliance was created](https://github.com/j54n1n/raspbian-mods/wiki/VirtualBox-Appliance-Image-Creation).
