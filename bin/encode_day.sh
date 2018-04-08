#!/bin/bash

function usage() {
  echo "Usage: `basename $0` control-file fps width height"
}

if [ $# -ne 4 ]; then
  usage
  exit 2
fi

ctrlfile=$1
fps=$2
width=$3
height=$4

basedir=/home/pi/svc/encode
outputdir=/home/pi/svc_web/video
ctrldir=$basedir/ctrl
bindir=$basedir/bin

encoder=mencoder

echo "Executing: $encoder mf://@${ctrldir}/${ctrlfile}.txt -mf w=${width}:h=${height}:fps=${fps}:type=jpg -o ${outputdir}/${ctrlfile}.avi -ovc lavc -lavcopts vcodec=mpeg4"

$encoder mf://@${ctrldir}/${ctrlfile}.txt -mf w=${width}:h=${height}:fps=${fps}:type=jpg -o ${outputdir}/${ctrlfile}.avi -ovc lavc -lavcopts vcodec=mpeg4

echo "Generated ${outputdir}/${ctrlfile}.avi successfully."
