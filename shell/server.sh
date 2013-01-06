#!/bin/bash

cpuNum=`cat /proc/cpuinfo | grep -c "model name"`
cpuName=`cat /proc/cpuinfo | grep -m 1 "model name" | cut -d: -f2 | sed 's/^[ ]*//; s/[ ]*$//'`

echo "cpuNum:$cpuNum"
echo "cpuName:$cpuName"
