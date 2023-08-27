#!/usr/bin/bash

mpiexecjl --project=./ -np $1 --oversubscribe julia ./src/gahpc.jl
