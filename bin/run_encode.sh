#!/bin/bash

#
# Steps:
#  a) Build file list to process.
#  b) Create video from files in file list using mencoder.
#

# Configuration
img_base_dir=/var/lib/tomcat8/webapps/svc/img
svc_home=/home/pi/svc
ctrl_dir=${svc_home}/encode/ctrl
svc_web=/home/pi/svc_web
svc_video=${svc_web}/video
log_file=${svc_home}/logs/encode.log
run_log_file=${svc_home}/logs/run_encode.log

function usage() {
  echo "Usage: `basename $0` input-directory frame-rate"
  exit 1
}

function log() {
  local message=$1
  local tstamp=$( date '+%FT%T' )
  echo "${tstamp}: ${message}" | tee -a ${run_log_file}
}

if [ $# -ne 2 ]; then
  usage
fi

# Sub folder beneath img_base_dir to find the images in.
input_dir=$1
frame_rate=$2

# Build image directory from base directory and input.
img_dir=${img_base_dir}/${input_dir}
log "Using image directory ${img_dir}"

# Full path to image file list to pass to mencoder command later.
ctrl_base=$( echo ${input_dir} | sed -e 's/\///g' )
ctrl_file=${ctrl_dir}/${ctrl_base}.txt

log "Using control file ${ctrl_file}"
ls ${img_dir}/*.jpg > ${ctrl_file}
num_lines=$( wc -l ${ctrl_file} | cut -f1 -d' ' )
log "Control file contains ${num_lines} lines."

log "Running encode.sh ${ctrl_base} ${frame_rate}"
${svc_home}/bin/encode.sh ${ctrl_base} ${frame_rate} >> ${log_file} 2>&1

ret=$?
if [ $ret -ne 0 ]; then
  log "Encoding failed with return code ${ret}, not purging images."
  exit 1
fi

video=${svc_video}/${ctrl_base}.avi
if [ -f ${video} ]; then
  log "Created video ${video} from files in ${input_dir}"
  log "Marking source image directory for purge."
  touch ${img_dir}/.purge
fi


