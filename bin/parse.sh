#!/bin/bash

#
# Splits a filename into month, day, hour, minute and second part.
#
function parse_and_copy() {
  local img=$1
  local y=$( date '+%Y' )
 
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

  echo "Image $img has been taken at ${y}-${m}-${d}T${hh}:${mi}:${ss}" 

  imgdir=$( printf '%4d/%02d/%02d/%02d' "${y}" "${m#0}" "${d#0}" "${hh#0}" )
  echo "Image Directory: ${imgdir}"
}


if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) filename"
  exit 1
fi

parse_and_copy $@
