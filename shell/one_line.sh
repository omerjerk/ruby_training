#!/bin/bash
grep -B 1 $(grep -o "[0-9]\{2,\}ms" file_ | sed -e 's/ms//g' | sort -nr | awk '{if(NR==1)print}')ms file_
