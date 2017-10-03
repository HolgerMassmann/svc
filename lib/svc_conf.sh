#!/bin/bash

#
# This file contains the common configuration for
# the SVC scripts.
#

#
# SVC base dir
#
svc_home=/home/pi/svc

#
# SVC default log directory
#
svc_logs=${svc_home}/logs

#
# Directory with contents published on the web
#
svc_web=/home/pi/svc_web

#
# The generated videos
#
svc_video=${svc_web}/video

#
# Base directory with the source images for video encoding
#
svc_img_dir=/var/lib/tomcat8/webapps/svc/img

#
# Directory containing the file lists for video encoding
#
svc_ctrl_dir=${svc_home}/encode/ctrl

#
# Trying to define a minimal generic logging facility in bash script
#
function log() {
  local tstamp=$( date '+%FT%T' )
  local message=$1

  if [ $# -eq 2 ]
   then
    local svc_log_file=$1
    local message=$2
  elif [ -z ${svc_log_file} ]
  then
    local svc_log_file=${svc_logs}/svc.log
  fi
  echo "${tstamp}: ${message}" | tee -a ${svc_log_file}
}

#
# Convenience funtion to print the configuration 
#
function print_config() {
  if [ $# -eq 0 ]; then
    local output=/dev/stdout
  else
    local output=$1
  fi

  log ${output} "svc_home=${svc_home}"
  log ${output} "svc_logs=${svc_logs}"
  log ${output} "svc_web=${svc_web}"
  log ${output} "svc_video=${svc_video}"
  log ${output} "svc_img_dir=${svc_img_dir}"
  log ${output} "svc_ctrl_dir=${svc_ctrl_dir}"
}

print_config $*
