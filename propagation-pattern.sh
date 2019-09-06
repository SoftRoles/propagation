#!/bin/bash

# propagation-pattern.sh 
#
# Author: Hüseyin YİĞİT
# Date: 05/09/2019
#

USAGE=$(cat <<-END
Definition:
    Antenna pattern tools   

Submodules:      
    draw   Draw antenna pattern on a map
 
END
)

if [[ "$#" -eq 0 ]]; then
  >&2 echo "$USAGE"
  exit 1
fi

if [[ "$#" -ge 1 ]]; then
  targs=${@/$1/}
  bash propagation-pattern-$1.sh $targs
fi

