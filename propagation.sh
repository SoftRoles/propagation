#!/bin/bash

# propagation.sh 
#
# Author: Hüseyin YİĞİT
# Date: 05/09/2019
#

USAGE=$(cat <<-END
Definition:
    Radio frequency propagation tools   

Submodules:      
    pattern :   Antenna pattern operations
 
END
)

if [[ "$#" -eq 0 ]]; then
#  >&2 echo -e "------\nError: illegal number of parameters!\n------"
  >&2 echo "$USAGE"
  exit 1
fi

if [[ "$#" -eq 1 ]] && [[ "$1" == "pattern" ]]; then
  echo "here"
  bash "propagation-pattern.sh"
fi

