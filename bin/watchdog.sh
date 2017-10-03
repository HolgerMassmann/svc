#!/bin/bash

base_dir=$HOME
program_name=raspistill
program_wrapper=${base_dir}/bin/capture_flipped.sh

img_dir=/var/lib/tomcat8/webapps/svc/img

function process_exists() {
  pid=$( pgrep ${program_name} )
  if [ $? -eq 0 ]; then
    echo "$( ps -fp ${pid} )"
    echo "${program_name} running, nothing to do."
    exit 0
  fi
}

process_exists

echo "Image capture not running, starting it..."
echo "${program_wrapper} 3000 640 400 r_ ${img_dir}"
${program_wrapper} 3000 640 400 r_ ${img_dir}
