#!/bin/bash

cpu=`cat /proc/cpuinfo | grep -m 1 "model name" | cut -d: -f2 | sed 's/^[ ]*//; s/[ ]*$//'`
cpuNum=`cat /proc/cpuinfo | grep -c "model name"`
memTotal=`cat /proc/meminfo | grep "MemTotal:" | cut -d: -f2 | sed 's/^[ ]*//;s/[ ]*$//'`
memFree=`cat /proc/meminfo | grep "MemFree:" | cut -d: -f2 | sed 's/^[ ]*//;s/[ ]*$//'`

echo "cpu: $cpu"
echo "cpuNum: $cpuNum"
echo "mem: $memFree/$memTotal"
