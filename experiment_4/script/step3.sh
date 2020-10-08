#!bin/bash

echo "==========backup ifcfg-enp0s3=========="
cp -p /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/ifcfg-enp0s3.bak

echo "==========move ifcfg-enp0s3 and ifcfg-br-ex=========="
cp script/ifcfg-enp0s3 /etc/sysconfig/network-scripts/
cp script/ifcfg-br-ex /etc/sysconfig/network-scripts/

echo "==========chmod 744 ifcfg-enp0s3 and ifcfg-br-ex=========="
chmod 744 /etc/sysconfig/network-scripts/ifcfg-enp0s3
chmod 744 /etc/sysconfig/network-scripts/ifcfg-br-ex

ip="$(hostname -i)"
echo "$ip"
sleep 5

echo "==========edit br-ex=========="
vim /etc/sysconfig/network-scripts/ifcfg-br-ex

echo "==========restart network=========="
systemctl restart network

echo "==========show ovs-vsctl=========="
ovs-vsctl show

echo "==========end=========="
