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

result=$(grep -Ewoi \
    -e '(4-?clause )?"?BSD"? licen[sc]es?' \
    -e '(4-?clause )?"?BSD"? LICEN[SC]es?' \
    -e '(Boost Software|mozilla (public)?|MIT) Licen[sc]es?' \
    -e '(CCPL|BSD|L?GPL)-[0-9a-z.+-]+( Licenses?)?' \
    -e 'Creative Commons( Licenses?)?' \
    -e 'Public Domain( Licenses?)?' \
    -e 'Permission to use' \
    -e 'Permission is hereby granted' \
    -e 'Permission is granted' \
    -e 'Redistribution and use' \
    -e 'You may not redistribute' \
    -e 'no restrictions' \
    -e 'can be freely distributed and used' \
    -e 'feel free to distribute' \
    -e 'Info-ZIP' \
    "$copyrightfile" | sed -r -e 's/[Ll]icence/License/g' -e 's/LICENCE/LICENSE/g' \
      -e 's/\"BSD\" License/BSD/g' \
      -e 's/\"BSD\" LICENSE/BSD/g' \
      -e 's/BSD license/BSD/g' \
      -e 's/[Pp]ermission to use/Permissive/g' \
      -e 's/[Pp]ermission is hereby granted/Permissive/g' \
      -e 's/[Pp]ermission is granted/Permissive/g' \
      -e 's/[Rr]edistribution and use/Permissive/g' \
      -e 's/no restrictions/Permissive/g' \
      -e 's/can be freely distributed and used/Permissive/g' \
      -e 's/[Ff]eel free to distribute/Permissive/g' \
      -e 's/GPL-compatible licenses/GPL-compatible/g' \
      -e 's/[Pp]ublic [Dd]omain/Public-Domain/g' \
      | tr a-z A-Z | sort -u)
if [ -n "$result" ]; then
  echo "$result"
fi

if [ ! -d  ../Reports/Image/Licenses/"$package" ]; then
	mkdir ../Reports/Image/Licenses/"$package"
	cp -f "$copyrightfile" ../Reports/Image/Licenses/"$package"
	mv -f ../Reports/Image/Licenses/"$package"/* ../Reports/Image/Licenses/"$package"/copyrightFile.txt
fi

exit 0

