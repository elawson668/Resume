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
#   fuzzy search for "License:" string in non-well-formatted files

set -e

package="$1"
copyrightfile=`find temp -iname "LICENSE.txt" -print`
if [ ! -f "$copyrightfile" ]; then
  copyrightfile=`find temp -iname "LICENSE" -print`
  if [ ! -f "$copyrightfile" ]; then
    copyrightfile=`find temp -iname "license.html" -print`
    if [ ! -f "$copyrightfile" ]; then
      copyrightfile=`find temp -iname "COPYING" -print`
      if [ ! -f "$copyrightfile" ]; then
        exit 0
      fi
    fi
  fi
fi

result=$(grep -e '^License:' -e '^Licence:' "$copyrightfile" | cut -d':' -f2-)
if [ -n "$result" ]; then
  echo "$result" | sed -r -e 's/ and /\n/g' -e 's/^ +//' -e 's/ +$//' -e 's/icence/icense/g' -e 's/LICENCE/LICENSE/g' | tr a-z A-Z | sort -u
fi

if [ ! -d  ../Reports/Java/Licenses/"$package" ]; then
    mkdir ../Reports/Java/Licenses/"$package"
    cp -f "$copyrightfile" ../Reports/Java/Licenses/"$package"
    mv -f ../Reports/Java/Licenses/"$package"/* ../Reports/Java/Licenses/"$package"/copyrightFile.txt
fi

exit 0

