#!/bin/bash

bash -x post.sh
gnuplot  tmp.gp
cp tmp.png ~/Dropbox/Public/tmp.png
cp st.png ~/Dropbox/Public/st.png
