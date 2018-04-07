#!/bin/bash

#
# Logging funtion (replace with generic version later).
#
function log() {
  local message=$1
  local tstamp=$( date '+%FT%T' )
  if [[ -w "$logfile" ]]; then
    echo "${tstamp}: ${message}" >> "${logfile}"
  else
    echo "${tstamp}: ${message}"
  fi
}
