#!/bin/bash
pwd
rm runs/wokwi/results/final/verilog/gl/*.nl.v
cp runs/wokwi/results/final/verilog/gl/*.v src/gate_level_netlist.v
cd src
make clean
GATES=yes make
# make will return success even if the test fails, so check for failure in the results.xml
! grep failure results.xml
