#!/bin/bash
cat input.txt | ruby -ane 'BEGIN{$sum=0}; $sum += $F.length == $F.map(&:chars).map(&:sort).uniq.length ? 1 : 0; END { puts $sum }'
