#!/bin/bash

#
# base directory.
#
camera_host=raspi.fritz.box
camera_user=pi
img_base_dir=/var/lib/tomcat8/webapps/svc/img
img_arch_dir=${img_base_dir}

run_log_file=$HOME/svc/logs/archive.log

#
# Logging funtion (replace with generic version later).
#
function log() {
  local message=$1
  local tstamp=$( date '+%FT%T' )
  echo "${tstamp}: ${message}" >> ${run_log_file}
}

#
# Splits a filename into month, day, hour, minute and second part.
#
function parse_and_copy() {
  local img=$1
  local y="2017"
 
  if [ ${#img} -eq 15 ]
  then
    local m=${img:2:1}
    local d=${img:3:2}
    local hh=${img:5:2}
    local mi=${img:7:2}
    local ss=${img:9:2}
  elif [ ${#img} -eq 16 ]
  then
    local m=${img:2:2}
    local d=${img:4:2}
    local hh=${img:6:2}
    local mi=${img:8:2}
    local ss=${img:10:2}
  fi

  log "Image $img has been taken at ${y}-${m}-${d}T${hh}:${mi}:${ss}" 

  imgdir=$( printf '%4d/%02d/%02d/%02d' "${y}" "${m#0}" "${d#0}" "${hh#0}" )
  src_path=${img_base_dir}/${img}
  dest_dir=${img_arch_dir}/${imgdir}
  dest_img=${img_arch_dir}/${imgdir}/${img}

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

function usage() {
  echo "Usage: `basename $0` file-list"
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

files=$*
for i in ${files}; do
  # echo ${i}
  parse_and_copy ${i}
done
