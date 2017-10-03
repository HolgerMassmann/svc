#!/bin/bash

function usage() {
  echo "Usage: `basename $0` day-of-month"
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

day=$1

year=2017
month=07

svc_dir=/home/pi/svc
encode_dir=/home/pi/svc/encode
imgbase_dir=/var/lib/tomcat8/webapps
imgday_dir=${imgbase_dir}/svc/img/${year}/${month}/${day}

hours=$( ls ${imgday_dir} )
echo "Directories in ${imgday_dir}: $( echo ${hours} | tr '\n' ' ' )"

for i in $hours
do
  filelist=${encode_dir}/ctrl/${year}${month}${day}${i}.txt
  echo "Generating file list for day/hour: ${day}/${i} into ${filelist}"
  ls ${imgday_dir}/${i}/* > ${filelist}
  if [ $? -ne 0 ]; then
    echo "Failed to generate image file list for ${imgday_dir}/${i}, skipping."
    continue
  fi

  echo "Running: ${svc_dir}/bin/encode.sh 201707${day}${i} 24 >> ${encode_dir}/logs/encode.log 2>&1"
  ${svc_dir}/bin/encode.sh 201707${day}${i} 24 >> ${encode_dir}/logs/encode.log 2>&1
done
