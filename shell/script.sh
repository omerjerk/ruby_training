#!/bin/bash
max=0
grep -o "[0-9]\{2,\}ms" tmp_more_than_50 | while read line
do
    # echo $line
    size=${#line}
    derp=$(expr $size - 2)
    num=$(echo "$line" | cut -c1-$derp)
    echo $num
    if [ $max -lt $num ];then
        max=$num
        echo $max
    fi
done
echo "max = $max"
