#!/usr/bin/env bash
# Copyright 2015 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# When run as (for example)
#
#	GOOS=linux GOARCH=ppc64 bootstrap.bash
#
# this script cross-compiles a toolchain for that GOOS/GOARCH
# combination, leaving the resulting tree in /go-${GOOS}-${GOARCH}-bootstrap.
# That tree can be copied to a machine of the given target type
# and used as $GOROOT_BOOTSTRAP to bootstrap a local build.
#
# Only changes that have been committed to Git (at least locally,
# not necessary reviewed and submitted to master) are included in the tree.

set -e

if [ "$GOOS" = "" -o "$GOARCH" = "" ]; then
	echo "usage: GOOS=os GOARCH=arch ./bootstrap.bash" >&2
	exit 2
fi

unset GOROOT


echo
echo "#### Downloading"
wget https://storage.googleapis.com/golang/go1.4-bootstrap-20170531.tar.gz

echo
echo "#### Extracting"
tar xf go1.4-bootstrap-20170531.tar.gz
mv go go-${GOOS}-${GOARCH}-bootstrap
cd go-${GOOS}-${GOARCH}-bootstrap

echo
echo "#### Cleaning"
rm -f .gitignore
if [ -e .git ]; then
	git clean -f -d
fi

echo
echo "#### Building"
echo
cd src
./make.bash --no-banner
./all.bash
gohostos="$(../bin/go env GOHOSTOS)"
gohostarch="$(../bin/go env GOHOSTARCH)"
goos="$(../bin/go env GOOS)"
goarch="$(../bin/go env GOARCH)"

# NOTE: Cannot invoke go command after this point.
# We're about to delete all but the cross-compiled binaries.
cd ..
if [ "$goos" = "$gohostos" -a "$goarch" = "$gohostarch" ]; then
	# cross-compile for local system. nothing to copy.
	# useful if you've bootstrapped yourself but want to
	# prepare a clean toolchain for others.
	true
else
	mv bin/*_*/* bin
	rmdir bin/*_*
	rm -rf "pkg/${gohostos}_${gohostarch}" "pkg/tool/${gohostos}_${gohostarch}"
fi
rm -rf pkg/bootstrap pkg/obj .git

echo ----
echo Bootstrap toolchain for "$GOOS/$GOARCH" installed in "$(pwd)".

echo Building package...
cd ..
tar zcf "go-${GOOS}-${GOARCH}-bootstrap.tar.gz" "go-${GOOS}-${GOARCH}-bootstrap"
echo Package is in "/go-${GOOS}-${GOARCH}-bootstrap.tar.gz"

exit 0

