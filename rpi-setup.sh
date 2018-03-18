#!/bin/bash
#
# MIT License
#
# Copyright (c) 2017 Julian Sanin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

readonly URL="https://raw.githubusercontent.com/rainerum-robotics-rpi/raspbian-mods/develop/"
readonly FILES="setup-raspbian.sh setup-rpi-desktop.sh setup.lib.sh prepare-vbox-appliance prepare-rpi-image"

for file in $FILES; do
  wget "$URL$file"
done

source "$(dirname $0)/setup.lib.sh"

if [ $ID = debian ]; then
  bash setup-rpi-desktop.sh
fi

if [ $ID = raspbian ]; then
  bash setup-raspbian.sh
fi

rm $FILES

exit 0
