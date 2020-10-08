#!bin/bash

echo "==========Create Vnfd=========="
echo "https://docs.openstack.org/tacker/latest/user/vnfm_usage_guide.html"
openstack vnf descriptor create --vnfd-file script/Vnfd.yaml vnfd

echo "==========Create VNF=========="

openstack vnf create --vnfd-name vnfd server

echo "==========end=========="
