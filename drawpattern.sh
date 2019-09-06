#!/bin/bash

# drawpattern.sh: Draws antenna pattern on a map 
#
# Author: Hüseyin YİĞİT
# Date: 04/09/2019
#
#

USAGE=$(cat <<-END
Definition:
    Draws antenna pattern on a map

    drawpattern <pattern_oid> <range>
    drawpattern --poid=<pattern_oid> --range=<range>

Arguments:      
    poid :   Pattern object id
    range:   Range for pattern maximum

Example:
    linspace 0 2 3
    >> 0 1.00000000000000000000 2.00000000000000000000
 
END
)

if [[ "$#" -ne 2 ]]; then
  >&2 echo -e "------\nError: illegal number of parameters!\n------"
  >&2 echo "$USAGE"
  exit 1
fi

# keyword arguments
if [[ "$1" == *"="* ]] && [[ "$2" == *"="* ]] && \
  [[ "$1" == "--"* ]] && [[ "$2" == "--"* ]]; then    
  first=${1/--/}
  second=${2/--/}
  IFS="="
  read -ra ARR1<<<"$first"
  read -ra ARR2<<<"$second"

  eval "${ARR1[0]}=${ARR1[1]}"
  eval "${ARR2[0]}=${ARR2[1]}"

  IFS=" "

  if [[ -z "$poid" ]] || [[ -z "$range" ]]; then
    >&2 echo -e "------\nError: unrecognized option!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi
fi

# positional arguments
if [[ -z "$poid" ]] && [[ -z "$range" ]]; then
  check=`echo "$1" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" == '' ]]; then    
    poid=$1
  else
    >&2 echo -e "------\nError: poid should be like MongoDB ObjectId string!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi

  check=`echo "$2" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    range=$2
  else
    >&2 echo -e "------\nError: range should be number in degrees!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi
fi

#find pattern maximum
ampmax=`json-find-max --db=antenna --col=pattern --oid=$poid --key=[.data[].amp]`
#ampmax=`echo $ampmax | awk '{print 10^($1/10);}'`
ampmax=`bc -l <<< "e(l(10)*($ampmax/10))"`
echo $ampmax

echo $poid
echo $range

echo ""

