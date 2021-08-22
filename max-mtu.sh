#!/bin/bash

# Determine the maximum MTU beteen the current host and a remote host
# Code from https://earlruby.org/2020/02/determine-maximum-mtu/

# Usage: max-mtu.sh $target_host

target_host=$1
size=1272
while ping -s $size -M do -c1 $target_host >&/dev/null; do
    ((size+=4));
done
echo "Max MTU size to $target_host: $((size-4+28))"
