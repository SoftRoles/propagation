#!/bin/bash

# propagation-radiohorizon.sh: Calculates radio horizon distance of an elevated antenna 
#
# Author: Hüseyin YİĞİT
# Date: 17/07/2019
# 

USAGE=$(cat <<-END
Usage:
    propagation-radiohorizon <height>
    propagation-radiohorizon --height=<height>

Arguments:      
    height:   Antenna elevation height in meters
 
END
)

if [[ "$#" -ne 1 ]]; then
  >&2 echo "error: illegal number of parameters!"
  >&2 echo "$USAGE"
  exit 1
fi

if [[ "$1" == *"="* ]] && [[ "$1" == "--"* ]]; then    
  first=${1/--/}
  IFS="="
  read -ra ARR1<<<"$first"

  if [[ ${ARR1} == "height" ]]; then
    height=${ARR1[1]}
  else
    >&2 echo "error: unrecognized option!"
    >&2 echo "$USAGE"
    exit 1
  fi  

  IFS=" "
fi


if [[ -z "$height" ]]; then  
  # echo "positional arguments"
  check=`echo "$1" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    height=$1
  else
    >&2 echo "error: height should be number!"
    >&2 echo "$USAGE"
    exit 1
  fi
fi

#echo $height

result=`bc -l <<< "4.12 * sqrt($height)"`
echo $result

