#!/bin/bash

echo "Get CentOS7 VM IP"

ip="$(hostname -i)"
echo "http://$ip:9890/"
