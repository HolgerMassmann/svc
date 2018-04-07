#!/bin/bash

#
# Splits a filename into month, day, hour, minute and second part.
# To generalize we need to know the length of the prefix.
# We assume that the prefix is separated from the remaining file name
# by an underscore. The remaining part consists of a timestamp
# using the format mddHHMMSS.jpg. m is either 1 (if month < 10) or
# 2 digits. 
#
function parse_image_file_name() {
  local img=$1
  local prefix="r_"

  if [ $# -eq 2 ]; then
    prefix="$2"
  fi

  offset=${#prefix}
  log "Using prefix=${prefix} (len=$offset)"

  # Determine raspistill filename without prefix.
  imgbase=${img/${prefix}/}
  log "Image base=${imgbase}"

  # Verify that prefix fits.
  imglen=${#img}
  imgbaselen=${#imgbase}

  log "Image filename length=${imglen}, image basename length=${imgbaselen}"

  if [ $imglen -eq $imgbaselen ]; then
    log "Prefix ${prefix} does not fit."
    return 1
  fi

  # For single digit months the image base len without prefix is 13
  # otherwise it is 14.
  offset=${#prefix}
  if [ ${imgbaselen} -eq 13 ]; then
    local m=${img:${offset}:1}
    let offset+=1
    local d=${img:${offset}:2}
    let offset+=2
    local hh=${img:${offset}:2}
    let offset+=2
    local mi=${img:${offset}:2}
    let offset+=2
    local ss=${img:${offset}:2}
  elif [ ${imgbaselen} -eq 14 ]; then
    local m=${img:${offset}:2}
    let offset+=2
    local d=${img:${offset}:2}
    let offset+=2
    local hh=${img:${offset}:2}
    let offset+=2
    local mi=${img:${offset}:2}
    let offset+=2
    local ss=${img:${offset}:2}
  else
    log "Unknown image file name format: ${img}"
    return 2
  fi

  local y=$( date '+%Y' )
  imgtime=$( printf '%4d-%02d-%02d %02d:%02d:%02d' "${y}" "${m#0}" "${d#0}" "${hh#0}" "${mi#0}" "${ss#0}" )
  echo "Image $img has been taken at ${imgtime}"

  imgdir=$( printf '%4d/%02d/%02d/%02d' "${y}" "${m#0}" "${d#0}" "${hh#0}" )
  echo "Image Directory: ${imgdir}"
}

