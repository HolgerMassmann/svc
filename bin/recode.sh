#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
  DIR="$PWD"
fi

#
# Import the log function.
#
. "$DIR/log.inc"

function usage() {
  log "Usage: $(basename $0) input-file output-file"
}

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

input_file=$1
output_file=$2

encoder=mencoder

#
# MEncoder Parameters
#
vcodec="-ovc x264"
fps="-ofps 24"
vcontainer="-of lavf"
vscale="-vf scale=1280:960"
vformat="-lavfopts format=mp4"
mvopts="$vcodec $vbitrate $fps $vcontainer $vscale $vformat"

vbitrate="bitrate=128"
level="level_idc=12"
partitions="partitions=all:8x8dct"

mencopts="-x264encopts $level:$bitrate:$partitions"

echo "Executing: ${encoder} ${mvopts} ${input_file} ${mencopts} -o ${output_file}"

${encoder} ${mvopts} ${input_file} ${mencopts} -o ${output_file}
