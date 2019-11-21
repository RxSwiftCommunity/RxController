#!/bin/bash

ROOT_DIR=$(cd $(dirname $0); pwd)

echo "Building rxtree..."

cd $ROOT_DIR
swift build
cp .build/debug/rxtree "$ROOT_DIR/../../../"