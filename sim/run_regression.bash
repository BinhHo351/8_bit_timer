#!/bin/bash

make build
find  ../testcases/ -type f -printf "%f\n" |sed 's/\.v//' | tee regress.list  #Work around
make regress
grep "RESULT" ./log/*.log #Work around
