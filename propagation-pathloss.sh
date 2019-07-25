#!/bin/bash

# propagation-pathloss.sh: Calculates propagation path loss over the distance for specific frequency 
#
# Author: Hüseyin YİĞİT
# Date: 17/07/2019
# 
# Usage: propagation-pathloss <frequency> <distance>

USAGE=$(cat <<-END
Usage:
    propagation-pathloss <frequency> <distance>
    propagation-pathloss --freq=<frequency> --dist=<distance>

Arguments:      
    frequency:   frequency in MHz
    distance :   calculation distance in km
 
END
)

if [[ "$#" -ne 2 ]]; then
  >&2 echo "error: illegal number of parameters!"
  >&2 echo "$USAGE"
  exit 1
fi

if [[ "$1" == *"="* ]] && [[ "$2" == *"="* ]] && [[ "$1" == "--"* ]] && [[ "$2" == "--"* ]]; then    
  first=${1/--/}
  second=${2/--/}
  IFS="="
  read -ra ARR1<<<"$first"
  read -ra ARR2<<<"$second"

  if [[ ${ARR1} == "freq" ]] && [[ ${ARR2} == "dist" ]]; then
    freq=${ARR1[1]}
    dist=${ARR2[1]}
  elif [[ ${ARR2} == "freq" ]] && [[ ${ARR1} == "dist" ]]; then
    freq=${ARR2[1]}
    dist=${ARR1[1]}
  else
    >&2 echo "error: unrecognized option!"
    >&2 echo "$USAGE"
    exit 1
  fi  

  IFS=" "
fi


if [[ -z "$dist" ]] && [[ -z "$freq" ]]; then  
  # echo "positional arguments"
  check=`echo "$1" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    freq=$1
  else
    >&2 echo "error: frequency should be number!"
    >&2 echo "$USAGE"
    exit 1
  fi

  check=`echo "$2" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    dist=$2
  else
    >&2 echo "error: distance should be number!"
    >&2 echo "$USAGE"
    exit 1
  fi
fi

#echo $freq
#echo $dist

result=`bc -l <<< "32.44 + 20*(l($freq*$dist)/l(10))"`
echo $result

