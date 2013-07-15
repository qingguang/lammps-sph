#!/bin/bash

awk '$1=="Atoms"&&NR>2{printf "\n"; next} NF>1&&NR>2{print}' $1
