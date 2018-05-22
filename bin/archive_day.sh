#!/bin/bash

#
# Get script directory.
#
DIR="${BASH_SOURCE%/*}"
if [[ -z $DIR ]]; then
  DIR=$(pwd)
fi

#
# Not needed so far.
#
camera_host=raspberry.fritz.box
camera_user=pi

#
# Base directory.
#
img_base_dir=/svc/data/images/daily
img_arch_dir=/svc/data/images/daily

run_log_file=$HOME/svc/logs/archive_day.log

#
# Defines log function
#
. "${DIR}/log_def.sh"

function usage() {
  log "Usage: $(basename ${0}) [prefix] file-pattern"
}

#
# Defines parse_and_copy function.
#
. "${DIR}/parse_def.sh"


#
# Actually copies the file.
#
function copy_image_file() {
  
  if [[ $# -ne 1 ]]; then
    log "Wrong number of parameters [$#], exiting..."
    return 4
  fi 

  if [[ -z $imgdir ]]; then
    log "Image directory not set, exiting..."
    return 4
  fi

  local img=$1
  local src_path=${img_base_dir}/${img}
  local dest_dir=${img_arch_dir}/${imgdir}
  local dest_img=${img_arch_dir}/${imgdir}/${img}

  # Verify the source image does indeed exist.
  if [ ! -r ${src_path} ]; then
    log "Image ${src_path} doesn not exist or is not readable, skipping..."
    return 1
  fi

  # Create destination directory if necessary.
  if [ ! -d ${dest_dir} ]; then
    log "Destination directory ${dest_dir} does not exist, creating it... "
    mkdir -p ${dest_dir}
    echo "done."
  fi

  echo "Copying ${src_path} to ${dest_img}"
  cp -p ${src_path} ${dest_dir}
  ret=$?

  if [ $ret -ne 0 ]; then
    echo "Could not copy ${src_path} to ${dest_dir} ($ret)".
    return 2
  fi

  if [ -r ${dest_img} ]; then
    log "Verified file ${dest_img} exists, deleting source image ${src_path}"
    rm ${src_path}
  else
    log "${dest_img} does not exist!"
  fi
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

# Go to image directory to ensure wildcard is expanded.
cd ${img_base_dir}
if [ $? -ne 0 ]; then
  log "Could not change directory to ${img_base_dir}, exiting."
  exit 3
fi

# First parameter is prefix.
prefix=$1
shift

files=$*
for i in ${files}; do
  # echo ${i}
  parse_image_file_name ${prefix} ${i}
  copy_image_file ${i}
done
