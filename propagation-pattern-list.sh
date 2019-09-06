#!/bin/bash

# propagation-pattern-list.sh 
#
# Author: Hüseyin YİĞİT
# Date: 19/07/2019
#
#

USAGE=$(cat <<-END
Definition:
    List antenna pattern in database   

Usage:
    propagation pattern list

Example:
    propagation pattern list
    >> isotropic directive ...
 
END
)

if [[ "$#" -lt 0 ]]; then
  >&2 echo -e "------\nError: illegal number of parameters!\n------"
  >&2 echo "$USAGE"
  exit 1
fi

result=`mongoexport --quiet -d antenna -c pattern | jq -c -r '.name'`
result=`mongoexport --quiet -d favorites -c links | jq -c -r '.url'`
echo $result
IFS=' ' read -r -a array <<< "$result"
echo ""
echo "${array[0]}"
echo "${array[1]}"
#for element in "${array[@]}"
#do
#  echo -n "$element"
#done
#IFS=' '
#for ((i=1; i<=1; i++)) do
#  result=`bc -l <<< "$start + ($i-1)*$delta"`
#  echo -n "$result "
#done
echo ""

