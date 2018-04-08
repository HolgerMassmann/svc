#!/bin/bash

#
# Steps:
#  a) Build file list to process.
#  b) Create video from files in file list using mencoder.
#

# Configuration
img_base_dir=/var/images/daily
svc_home=/home/pi/svc
ctrl_dir=${svc_home}/encode/ctrl
svc_web=/home/pi/svc_web
svc_video=${svc_web}/video
log_file=${svc_home}/logs/encode_day.log
run_log_file=${svc_home}/logs/run_encode_day.log

encode_cmd=${svc_home}/bin/encode_day.sh

min_image_count=50

function usage() {
  echo "Usage: `basename $0` input-directory frame-rate width height"
  exit 1
}

function log() {
  local message=$1
  local tstamp=$( date '+%FT%T' )
  echo "${tstamp}: ${message}" | tee -a ${run_log_file}
}

if [ $# -ne 4 ]; then
  usage
  exit 1
fi

# Sub folder beneath img_base_dir to find the images in.
input_dir=$1
frame_rate=$2
width=$3
height=$4

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

#
# Need to verify there are n entries in the control file,
# otherwise skip remaining steps.

if [ $num_lines -lt ${min_image_count} ]; then
  log "Too few lines in control file, skipping video generation."
  exit 1
fi

log "Running ${encode_cmd} ${ctrl_base} ${frame_rate} ${width} ${height}"
${encode_cmd} ${ctrl_base} ${frame_rate} ${width} ${height} >> ${log_file} 2>&1

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


