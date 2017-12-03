#!/bin/bash
cat input.txt | ruby -ane 'BEGIN{$sum=0}; row = $F.map(&:to_i).sort; $sum += row.map {|f| row.select {|field| f % field == 0 }.sort.reverse}.select {|res| res.length > 1}.map {|pair| pair.inject(:/)}.inject(:+); END {puts $sum}'
