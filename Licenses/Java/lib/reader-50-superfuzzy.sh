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
#   fuzzy search for known licence names

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
        copyrightfile=`find temp -iname "LICENSE-junit.txt" -print`
        if [ ! -f "$copyrightfile" ]; then
          copyrightfile=`find temp -iname "about.html" -print`
          if [ ! -f "$copyrightfile" ]; then
            copyrightfile=`find temp -iname "*.LICENSE" -print`
            if [ ! -f "$copyrightfile" ]; then
              exit 0
            fi
          fi
        fi
      fi
    fi
  fi
fi

result=$(grep -Ewoi \
    -e '(4-?clause )?"?BSD"? licen[sc]es?' \
    -e '(4-?clause )?"?BSD"? LICEN[SC]es?' \
    -e '(Boost Software|mozilla (public)?|MIT) Licen[sc]es?' \
    -e '(CCPL|BSD|L?GPL)-[0-9a-z.+-]+( Licenses?)?' \
    -e 'Creative Commons?( Licenses?)?' \
    -e '[Ee]clipse ([Pp]ublic)? [Ll]icenses?' \
    -e '[Aa]pache [Ll]icense' \
    -e 'GNU General Public License' \
    -e 'GNU GPL' \
    -e 'Open Font License' \
    -e 'Knuth License' \
    -e 'Public Domain( Licenses?)?' \
    -e 'Permission to use' \
    -e 'Permission to copy' \
    -e 'Permission is hereby granted' \
    -e 'Permission is granted' \
    -e 'Redistribution and use' \
    -e 'You may not redistribute' \
    -e 'no restrictions' \
    -e 'can be freely distributed and used' \
    -e 'feel free to distribute' \
    -e 'free license' \
    -e 'Info-ZIP' \
    "$copyrightfile" | sed -r -e 's/[Ll]icence/License/g' -e 's/LICENCE/LICENSE/g' \
      -e 's/\"BSD\" License/BSD/g' \
      -e 's/\"BSD\" LICENSE/BSD/g' \
      -e 's/BSD license/BSD/g' \
      -e 's/GNU General Public License/GPL/g' \
      -e 's/GNU GPL/GPL/g' \
      -e 's/[Pp]ermission to use/Permissive/g' \
      -e 's/[Pp]ermission to copy/Permissive/g' \
      -e 's/[Pp]ermission is hereby granted/Permissive/g' \
      -e 's/[Pp]ermission is granted/Permissive/g' \
      -e 's/[Rr]edistribution and use/Permissive/g' \
      -e 's/no restrictions/Permissive/g' \
      -e 's/can be freely distributed and used/Permissive/g' \
      -e 's/[Ff]eel free to distribute/Permissive/g' \
      -e 's/free license/Permissive/g' \
      -e 's/GPL-compatible licenses/GPL-compatible/g' \
      -e 's/[Pp]ublic [Dd]omain/Public-Domain/g' \
      -e 's/Creative Common\>/Creative Commons/g' \
      | tr a-z A-Z | sort -u)
if [ -n "$result" ]; then
  echo "$result"
fi

if [ ! -d  ../Reports/Java/Licenses/"$package" ]; then
    mkdir ../Reports/Java/Licenses/"$package"
    cp -f "$copyrightfile" ../Reports/Java/Licenses/"$package"
    mv -f ../Reports/Java/Licenses/"$package"/* ../Reports/Java/Licenses/"$package"/copyrightFile.txt
fi

exit 0

