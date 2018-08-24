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
#   Parses /usr/share/doc/$package/copyright according to:
#   http://dep.debian.net/deps/dep5/

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

format=$(awk '/^Format:/{print}/^$/{exit}' "$copyrightfile")
[ -n "$format" ] || exit 0

case "$format" in
  *'://www.debian.org/doc/packaging-manuals/copyright-format/1.0'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://dep.debian.net/deps/dep5'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://anonscm.debian.org/viewvc/dep/web/deps/dep5.mdwn?'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://svn.debian.org/wsvn/dep/web/deps/dep5.mdwn?'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *'http://anonscm.debian.org/loggerhead/dep/dep5/trunk/annotate/179/dep5/copyright-format.xml'*)
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  "Format:")  # seen in /usr/share/doc/libpcsclite1/copyright
    result=$(grep '^License:' "$copyrightfile" | cut -d':' -f2-)
    ;;
  *)
    echo "WARNING: Unknown format of $copyrightfile: $format" >&2
    exit 1  # unknown format
esac

if [ -n "$result" ]; then
  echo "$result" | sed -r -e 's/ and /\n/g' -e 's/^ +//' -e 's/ +$//' \
    -e 's/icence/icense/g' -e 's/ICENCE/ICENSE/g' \
    -e 's/~/-/g' \
    -e 's/ \| / OR /g' -e 's/ \|/ OR /g' -e 's/\| / OR /g' -e 's/\|/ OR /g' \
    -e 's/Apache-2/Apache-2.0/g' \
    -e 's/Apache 2.0/Apache-2.0/g' \
    -e 's/Apache-2.0.0/Apache-2.0/g' \
    -e 's/Beerware/BEER-WARE/g' \
    -e 's/BSD 2-clause/BSD-2/g' \
    -e 's/BSD-2-[Cc]lause/BSD-2/g' \
    -e 's/BSD3/BSD-3/g' \
    -e 's/BSD-3-cluase/BSD-3-Clause/g' \
    -e 's/BSD-3-[Cc]lause/BSD-3/g' \
    -e 's/BSD 4-clause/BSD-4-Clause/g' \
    -e 's/or Artistic,/or artistic/g' \
    -e 's/AFL-2.1,/AFL-2.1/g' \
    -e 's/freely-redistributable/Permissive/g' \
    -e 's/This code is in the public domain\./Public-Domain/g' \
    -e 's/[Pp]ubl?ic ?-?[Dd]omain/Public-Domain/g' \
    -e 's/BSL-1/BSL/g' \
    -e 's/CC0-1.0/CC0/g' \
    -e 's/CUSTOM_LICENSE/CUSTOM/g' \
    -e 's/GPL-1/GPL/g' \
    -e 's/with other exception/with exception/g' \
    -e 's/-with-exceptions/ with exceptions/g' \
    -e 's/GPL-2.0/GPL-2/g' \
    -e 's/GPL-3.0/GPL-3/g' \
    -e 's/GPL-3+\./GPL-3+/g' \
    -e 's/GPL1+/GPL+/g' \
    -e 's/GPL2+/GPL-2+/g' \
    -e 's/GPL3+/GPL-3+/g' \
    -e 's/GPL-3+\./GPL-3+/g' \
    -e 's/LGPL\.1+/LGPL-1+/g' \
    -e 's/LGPLv3/LGPL-3/g' \
    -e 's/LPGL/LGPL/g' \
    -e 's/The MIT license/MIT/g' \
    -e 's/MIT license/MIT/g' \
    -e 's/MIT\/X11/MIT-X11/g' \
    -e 's/MIT\/X/MIT-X/g' \
    -e 's/REGCOMP,/REGCOMP/g' \
    -e 's/all-permissive/Permissive/g' \
    -e 's/zlib\/libpng/zlib-png/g' \
    -e 's/Expat\/MIT/Expat-MIT/g' \
    | tr a-z A-Z | sort -u
fi

if [ ! -d  ../Reports/Java/Licenses/"$package" ]; then
    mkdir ../Reports/Java/Licenses/"$package"
    cp -f "$copyrightfile" ../Reports/Java/Licenses/"$package"
    mv -f ../Reports/Java/Licenses/"$package"/* ../Reports/Java/Licenses/"$package"/copyrightFile.txt
fi

exit 0

