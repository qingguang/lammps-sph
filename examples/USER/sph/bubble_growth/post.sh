#! /bin/bash

cd data-ndim3
PYTHONPATH=${HOME}/work/Pizza.py/src/ python ../../scripts/dump2ensight.py dump*.dat
