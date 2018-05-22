#!/bin/bash

#
# Get script directory.
#
DIR="${BASH_SOURCE%/*}"
if [[ -z $DIR ]]; then
  DIR=$(pwd)
fi

#
# Source log function.
#
. "$DIR/log_def.sh"

#
# Splits a filename into month, day, hour, minute and second part.
#
function parse_image_file_name() {
  local prefix=r_
  if [[ $# -eq 2 ]]; then
    prefix=$1
    shift
  fi
  local img=$1

  # Calculate file name length.
  len=${#prefix}
  let single_digit_len=${#prefix}+13
  let two_digit_len=${#prefix}+14
  log "Image file name length=${single_digit_len}"

  local y=$( date '+%Y' )
 
  if [ ${#img} -eq ${single_digit_len} ]
  then
    local m=${img:${len}:1}
    local d=${img:$((len+1)):2}
    local hh=${img:$((len+3)):2}
    local mi=${img:$((len+5)):2}
    local ss=${img:$((len+7)):2}
  elif [ ${#img} -eq ${two_digit_len} ]
  then
    local m=${img:${len}:2}
    local d=${img:$((len+2)):2}
    local hh=${img:$((len+4)):2}
    local mi=${img:$((len+6)):2}
    local ss=${img:$((len+8)):2}
  fi

  log "Image $img has been taken at ${y}-${m}-${d}T${hh}:${mi}:${ss}" 

  imgdir=$( printf '%4d/%02d/%02d/%02d' "${y}" "${m#0}" "${d#0}" "${hh#0}" )
  log "Image Directory: ${imgdir}"
}


if [ $# -gt 2 ]; then
  log "Usage: $(basename $0) [prefix] filename"
  exit 1
fi

parse_image_file_name $@
