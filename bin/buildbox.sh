#!/bin/bash

set -x

if [ -z "$SILENT" ]; then
OPTS="--auto --force"
else
OPTS="--auto --nogui --force"
fi
VAGRANT="bundle exec vagrant"
VEEWEE="bundle exec veewee"

BOX=$1

function buildbox {
	$VEEWEE vbox build $OPTS $BOX &&
	$VAGRANT basebox export --force $BOX 
}

function cleanup {
	$VAGRANT basebox destroy -n $BOX 
}

trap cleanup EXIT

buildbox 2>&1

trap - EXIT
cleanup
exit 0
