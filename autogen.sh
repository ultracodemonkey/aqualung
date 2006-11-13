#!/bin/sh

echo "
checking basic compilation tools ...
"

for tool in pkg-config aclocal autoheader autoconf automake gettext msgfmt iconv
do
    echo -n "$tool... "
    if which $tool >/dev/null 2>&1 ; then
	echo "found."
    else
	echo "not found.

*** You do not have $tool correctly installed. You cannot build aqualung without this tool."
	exit 1
    fi
done

echo

for tool in aclocal autoheader autoconf automake
do
    echo -n "running $tool... "
    if $tool; then
	echo "done."
    else
	echo "faled.

*** $tool returned an error."
	exit 1
    fi
done


echo -n "bootstrapping src/version.h... "

cd src
if test -e version.h; then
    svn_v1="`cat version.h`"; else svn_v1=""
fi
if test -e .svn; then
    svn_v2="#define AQUALUNG_VERSION \"R-`cd ..; svn info | grep '^Revision' | awk '{print $2}'`\""
else
    svn_v2="$svn_v1"
fi
if test "$svn_v1" != "$svn_v2"; then
    echo "$svn_v2" > version.h
fi

echo "done."

echo "
You can now run:

    ./configure
    make
    make install

Please take the time to subscribe to the project mailing list at:
http://lists.sourceforge.net/lists/listinfo/aqualung-friends

"
