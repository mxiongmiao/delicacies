#!/bin/bash

cpu=`more /proc/cpuinfo | grep -m 1 "model name" | cut -d: -f2 | sed 's/^[ ]*//; s/[ ]*$//'`
cpuNum=`more /proc/cpuinfo | grep -c "model name"`
memTotal=`more /proc/meminfo | grep "MemTotal:" | cut -d: -f2 | sed 's/^[ ]*//;s/[ ]*$//'`
memFree=`more /proc/meminfo | grep "MemFree:" | cut -d: -f2 | sed 's/^[ ]*//;s/[ ]*$//'`
uptime=`uptime | sed 's/^[ ]*//; s/[ ]*$//'`

echo "cpu:"
echo "$cpu"
echo "cpuNum:"
echo "$cpuNum"
echo "mem:"
echo "$memFree/$memTotal"
echo "uptime:"
echo "$uptime"
