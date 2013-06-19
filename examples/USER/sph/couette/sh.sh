#!/bin/bash

for poi in poi*; do
    mv  ${poi} ${poi/couette/couette}
done
