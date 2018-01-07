#!/bin/bash

#
# Run from cronjob to delete image directories
# marked with .purge tag.
#

. /home/pi/svc/lib/svc_conf.sh

if [ $# -eq 1 ]
then
  purge_log=$1
fi

log ${purge_log} "Looking for directories to purge using find ${svc_img_dir} -name \.purge -mtime +0"

img_dirs=$( find ${svc_img_dir} -name \.purge -mtime +0 )
num_dirs=$( echo -n "${img_dirs}" | wc -l )

log ${purge_log} "Found $num_dirs directories in ${svc_img_dir} to purge"

if [ ${num_dirs} -lt 1 ]
then
  log ${purge_log} "No directories to purge, exiting."
  exit 0
fi

#
# Deletes the JPG images in a directory.
#
function purge_dir() {
  if [ $# -ne 1 ]
  then
    log ${purge_log} "Directory argument missing, skipping..."
    return 1
  fi

  local purge_dir=$( echo ${i} | sed -e 's/\/\.purge//' )
  log ${purge_log} "Deleting images in ${purge_dir} using rm -f ${purge_dir}/*.jpg"
  rm -f ${purge_dir}/*.jpg
  if [ $? -ne 0 ]
  then
    log ${purge_log} "Could not purge images from ${purge_dir}"
  else
    log ${purge_log} "Deleting purge marker"
    rm -f ${purge_dir}/.purge
  fi
}

for i in ${img_dirs}
do
  purge_dir ${i}
done

log ${purge_log} "Purged images from ${num_dirs} directories successfully."
