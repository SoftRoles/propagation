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
    list :   List antenna patterns in database
 
END
)

if [[ "$#" -eq 0 ]]; then
  >&2 echo "$USAGE"
  exit 1
fi

if [[ "$#" -eq 1 ]] && [[ "$1" == "list" ]]; then
  echo "here"
  bash "propagation-pattern-list.sh"
fi

