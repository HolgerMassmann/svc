#!/bin/bash

width=1280
height=960

function usage() {
  echo "Usage: `basename $0` control-file fps"
}

if [ $# -ne 2 ]; then
  usage
  exit 2
fi

ctrlfile=$1
fps=$2

basedir=/home/pi/svc/encode
outputdir=/home/pi/svc_web/video
ctrldir=$basedir/ctrl
bindir=$basedir/bin

encoder=mencoder

echo "Executing: $encoder mf://@${ctrldir}/${ctrlfile}.txt -mf w=${width}:h=${height}:fps=${fps}:type=jpg -o ${outputdir}/${ctrlfile}.avi -ovc lavc -lavcopts vcodec=mpeg4"

$encoder mf://@${ctrldir}/${ctrlfile}.txt -mf w=${width}:h=${height}:fps=${fps}:type=jpg -o ${outputdir}/${ctrlfile}.avi -ovc lavc -lavcopts vcodec=mpeg4

echo "Generated ${outputdir}/${ctrlfile}.avi successfully."
