#!/bin/bash

#1- isolate the water

convert water.png -matte \( +clone -fuzz 15% -transparent "#111f26" \) -compose DstOut -composite water_iso.png


