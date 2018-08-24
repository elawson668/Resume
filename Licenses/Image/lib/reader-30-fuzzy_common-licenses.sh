#!/bin/bash
#
#    Copyright 2016 Daniel Alder, https://github.com/daald
#
#    This file is part of dpkg-licenses.
#
#    dpkg-licenses was written by Daniel Alder, https://github.com/daald
#
#    dpkg-licenses is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dpkg-licenses is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dpkg-licenses.  If not, see <http://www.gnu.org/licenses/>.
#
#    Modified by Eric Lawson, 2018

# Description:
#   fuzzy search for references to: /usr/share/common-licenses/

set -e

package="$1"
copyrightfile=
if [ -f "/usr/share/doc/$package/copyright" ]; then
  copyrightfile="/usr/share/doc/$package/copyright"
elif [ -f "/usr/share/doc/${package%:*}/copyright" ]; then
  copyrightfile="/usr/share/doc/${package%:*}/copyright"
elif [ -f "/usr/share/doc/$package/LICENSE" ]; then
  copyrightfile="/usr/share/doc/$package/LICENSE"
elif [ -f "/usr/share/doc/${package%:*}/LICENSE" ]; then
  copyrightfile="/usr/share/doc/${package%:*}/LICENSE"
elif [ -f "/usr/share/doc/$package/LICENSE.txt" ]; then
  copyrightfile="/usr/share/doc/$package/LICENSE.txt"
elif [ -f "/usr/share/doc/${package%:*}/LICENSE.txt" ]; then
  copyrightfile="/usr/share/doc/${package%:*}/LICENSE.txt"
else
  exit 0  # no copyright file found
fi

result=$(grep -oPi '/usr/share/common-licenses/[0-9A-Za-z_.+-]+[0-9A-Za-z+]' "$copyrightfile" | cut -d/ -f5- | tr a-z A-Z | sort -u)
if [ -n "$result" ]; then
  echo "$result"
fi

if [ ! -d  ../Reports/Image/Licenses/"$package" ]; then
	mkdir ../Reports/Image/Licenses/"$package"
	cp -f "$copyrightfile" ../Reports/Image/Licenses/"$package"
	mv -f ../Reports/Image/Licenses/"$package"/* ../Reports/Image/Licenses/"$package"/copyrightFile.txt
fi

exit 0

