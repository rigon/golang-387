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

if [ "$GOVER" = "" ]; then
	# Default Go version
	GOVER=1.9
fi

if [ "$GOOS" = "" -o "$GOARCH" = "" ]; then
	echo "usage: GOOS=os GOARCH=arch GOROOT_BOOTSTRAP=boostrap_dir GOVER=version ./buildgo.bash" >&2
	exit 2
fi

if [ "$GOROOT_BOOTSTRAP" = "" ]; then
	export GOROOT_BOOTSTRAP=/go-${GOOS}-${GOARCH}-bootstrap
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
./all.bash


echo ----
echo Go compiler for "$GOOS/$GOARCH" installed in "$(pwd)".

echo Building package...
cd ..
tar zcf "go${GOVER}-${GOOS}-${GOARCH}.tar.gz" "go-${GOOS}-${GOARCH}"
echo Package is in "$/go${GOVER}-${GOOS}-${GOARCH}.tar.gz"

exit 0

