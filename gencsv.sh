#!/bin/bash
RANDOM=$$
DEFAULT_VALUE=10
random_no_range="${1:-$DEFAULT_VALUE}"
for i in `seq $random_no_range`
do
 echo $((i-1)), $RANDOM
done > inputFile
chmod o+r inputFile
