#!/bin/bash

# propagation-pattern-draw.sh
#
# Author: Hüseyin YİĞİT
# Date: 04/09/2019
#
#

USAGE=$(cat <<-END
Definition:
    Draws antenna pattern on a map

    propagation pattern draw <name> <lat> <lng> <range>
    propagation pattern draw --name=<name> --lat=<latitude> --lng=<longitude> --range=<range>

Arguments:      
    name    Pattern name
    lat     Latitude of antenna position
    lng     Longitude of antenna position
    range   Range for pattern maximum in km

Example:
    >> propagation pattern draw isotropic 29.0000 40.00000 13.567
    0 1.00000000000000000000 2.00000000000000000000
 
END
)

if [[ "$#" -ne 4 ]]; then
#  >&2 echo -e "------\nError: illegal number of parameters!\n------"
  >&2 echo "$USAGE"
  exit 1
fi


# keyword arguments
if [[ "$1" == *"="* ]] && [[ "$2" == *"="* ]] && [[ "$3" == *"="* ]] && [[ "$4" == *"="* ]] && \
  [[ "$1" == "--"* ]] && [[ "$2" == "--"* ]] && [[ "$3" == "--"* ]] && [[ "$4" == "--"* ]]; then    
  first=${1/--/}
  second=${2/--/}
  third=${3/--/}
  fourth=${4/--/}
  IFS="="
  read -ra ARR1<<<"$first"
  read -ra ARR2<<<"$second"
  read -ra ARR3<<<"$third"
  read -ra ARR4<<<"$fourth"
  eval "${ARR1[0]}=${ARR1[1]}"
  eval "${ARR2[0]}=${ARR2[1]}"
  eval "${ARR3[0]}=${ARR3[1]}"
  eval "${ARR4[0]}=${ARR4[1]}"
  IFS=" "

  if [[ -z "$name" ]] || [[ -z "$lat" ]] || [[ -z "$lng" ]] || [[ -z "$range" ]]; then
    >&2 echo -e "------\nError: unrecognized option!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi
fi

# positional arguments
if [[ -z "$name" ]] && [[ -z "$lat" ]] && [[ -z "$lng" ]] && [[ -z "$range" ]]; then
  check=`echo "$1" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" == '' ]]; then    
    name=$1
  else
    >&2 echo -e "------\nError: name should be string like!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi

  check=`echo "$2" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    lat=$2
  else
    >&2 echo -e "------\nError: latitude should be number in degrees!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi

  check=`echo "$3" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    lng=$3
  else
    >&2 echo -e "------\nError: longitude should be number in degrees!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi

  check=`echo "$4" | grep -E ^\-?[0-9]*\.?[0-9]+$`
  if [[ "$check" != '' ]]; then    
    range=$4
  else
    >&2 echo -e "------\nError: range should be number in meters!\n------"
    >&2 echo "$USAGE"
    exit 1
  fi
fi


echo $name
echo $lat
echo $lng
echo $range

#find pattern maximum
#ampmax=`json-find-max --db=antenna --col=pattern --oid=$name --key=[.data[].amp]`
#ampmax=`echo $ampmax | awk '{print 10^($1/10);}'`
#ampmax=`bc -l <<< "e(l(10)*($ampmax/10))"`
#echo $ampmax


echo ""

