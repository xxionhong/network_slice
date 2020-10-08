#!bin/bash

echo "use Tacker to create VNF
=====================================\n
source keystonerc_admin
\n====================================="

echo "=====================================\n
openstack network create --share --external \
--provider-physical-network extnet \
--provider-network-type flat public
\n=====================================
"
echo "=====================================\n
openstack subnet create --network public \
--allocation-pool start=192.168.0.20,end=192.168.0.40 \
--gateway 192.168.0.1 \
--subnet-range 192.168.0.0/24 public
\n====================================="
echo "*****end*****"
