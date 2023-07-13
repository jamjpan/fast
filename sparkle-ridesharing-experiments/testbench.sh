#!/usr/bin/env bash

source ~/.profile

echo $SPARKLE
echo $SPARKLE_RS

julia -t 4 -- testbench.jl $SPARKLE $SPARKLE_RS pp tick icache slack 100 4000 2.0 12 1 4
