#!/bin/bash

#
# Source utility functions.
#
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
  DIR="$PWD"
fi
. "$DIR/log.inc"
. "$DIR/parse.inc"


if [ $# -lt 1 -o $# -gt 2 ]; then
  echo "Usage: $(basename $0) filename [prefix]"
  exit 1
fi

parse_and_copy $@
