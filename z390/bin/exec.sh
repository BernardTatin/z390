#!/bin/bash

ici=$(pwd)
source ~/git/z390/z390/bin/z390-env.sh
source ${z390_bin}/shlib.sh
echo "$0 - $z390_bin - $z390_home - $@"

main=${zcobol_works}/$1
shift
# exec execute 390 load module
rm -fv $1.log $1.err $1.sta $1.tr*
${z390_bin}/ez390.sh $main $@ ||
	onerror 1 "see errors on ez390 generated log file and console"
