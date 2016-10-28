#!/bin/bash

export z390_home=~/git/z390/z390
export z390_bin=${z390_home}/bin
export zcobol_home=${z390_home}/zcobol

export PATH=${z390_bin}:$PATH

export zcobol_works=${zcobol_home}/works

# export J2SEOPTIONS="$J2SEOPTIONS -esa -verbose:class -XshowSettings:all"

cd ${z390_home}