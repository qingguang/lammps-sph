#! /bin/bash

if [ $# -eq 1 ]; then
    tac "$1" | awk 'NF==2{f=1} !f'    
else
    # the number of profile
    n=$2
    awk -v n=${n} 'f==n&&NF==4; NF==2{f++};  f>n{exit}' $1
fi

