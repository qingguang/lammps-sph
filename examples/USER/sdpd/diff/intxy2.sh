#!/bin/bash

finput="\"c1.44e+02-ndim2-eta8.0-sdpd_background0.0-nx30-n5.00e+00-ktypelaguerrewendland4/dump00040000.dat\""
for ncut in 3.0 3.5 4.0 4.5 5.0 5.5 6.0; do
    maxima -r "finput: ${finput}; ncut: ${ncut}; batchload(\"intxy2.mac\")$"
done
