#!/bin/bash
awk '{min=$1;max=$1;for(i=1;i<=NF;i++) if($i<min)min=$i;else if($i>max)max=$i; print (max - min)}' input.txt | awk '{ sum+=$1} END {print sum}'
