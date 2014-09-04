#!/bin/bash

set -x
set -e

if [ -z "$SILENT" ]; then
OPTS=""
else
OPTS=""
fi
PACKER="packer"
BOX=$1

function buildbox {
	cd definitions/$BOX
	$PACKER build $OPTS $BOX.json
	mv $BOX.box ../../
}

function cleanup {
	return 1
}

trap cleanup EXIT

buildbox 2>&1

trap - EXIT
cleanup || true
exit 0
