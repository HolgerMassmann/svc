#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: `basename $0` file-pattern"
  exit 1
fi

base_dir=/home/pi/svc
${base_dir}/bin/archive.sh $*
