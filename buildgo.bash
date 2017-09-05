#!/usr/bin/env bash
#
# When run as (for example)
#
#	GOOS=linux GOARCH=ppc64 buildgo.bash
#
# this script cross-compiles Go for that GOOS/GOARCH
# combination, leaving the resulting tree in /go-${GOOS}-${GOARCH}.
# That tree can be copied to a machine of the given target type
# and used as $GOROOT to compile Go programs.

# Exit if an error occurs
set -e

if [ "$GOVER" = "" ]; then
	# Default Go version
	GOVER=1.9
fi

if [ "$GOOS" = "" -o "$GOARCH" = "" -o "$#" -gt "1" ]; then
	echo "usage: GOOS=os GOARCH=arch GOROOT_BOOTSTRAP=boostrap_dir GOVER=version ./buildgo.bash [output_dir]" >&2
	exit 2
fi

if [ "$GOROOT_BOOTSTRAP" = "" ]; then
	export GOROOT_BOOTSTRAP=$PWD/go-${GOOS}-${GOARCH}-bootstrap
fi

# Output dir for package
if [ "$#" -eq "1" ]; then
	pkgdir="$1"
else
	pkgdir="$PWD"
fi


echo
echo "#### Downloading"
wget https://storage.googleapis.com/golang/go${GOVER}.src.tar.gz

echo
echo "#### Extracting"
tar xf go${GOVER}.src.tar.gz
mv go go${GOVER}-${GOOS}-${GOARCH}

echo
echo "#### Building"
cd go${GOVER}-${GOOS}-${GOARCH}/src
./make.bash --no-banner
./all.bash


echo ----
echo Go compiler for "$GOOS/$GOARCH" installed in "$(pwd)".

echo Building package...
cd ..
tar zcf "${pkgdir}/go${GOVER}-${GOOS}-${GOARCH}.tar.gz" "go${GOVER}-${GOOS}-${GOARCH}"
echo Package is in "${pkgdir}/go${GOVER}-${GOOS}-${GOARCH}.tar.gz"

exit 0

