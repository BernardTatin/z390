#!/bin/bash

echo "$0 - $z390_bin - $z390_home - $@"
source ~/git/z390/z390/bin/z390-env.sh
source ${z390_bin}/shlib.sh
# execute zc390 with java runtime options:
# -classpath  path to jar file
# -verbose:gc trace garbage collection to detect memory leaks
# -XmsnK      set initial memory allocation to nK
# -XmxnK      set max     memory allocation to nK
# -Xrs        allow control break interruption of java tasks
java -classpath ${z390_home}/z390.jar -Xrs zc390 $@

