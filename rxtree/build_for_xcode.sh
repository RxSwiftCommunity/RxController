#!/bin/bash

ROOT_DIR=$(cd $(dirname $0); pwd)

cd "$ROOT_DIR/../../../"

if [ ! -f .rxtree-version ]; then
    echo "0.0" > .rxtree-version
fi

VERSION=$(cat Podfile.lock | grep RxController\ \( | sed -e 's/  - RxController (//g' | sed -e 's/)://g')

if [ $(cat .rxtree-version) = ${VERSION} ] && [ -f rxtree ]; then
    echo "rxtree ${VERSION} existed, skip."
else
	echo "Building rxtree $VERSION..."
	echo $VERSION > .rxtree-version
	cd $ROOT_DIR
	swift build
	cp .build/debug/rxtree "$ROOT_DIR/../../../"
fi