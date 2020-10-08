#!/bin/bash
echo "==========check SELINUX=========="
sestatus
sleep 5

echo "==========install centos-release-openstack-train=========="
systemctl restart network
yum install -y centos-release-openstack-train


echo "==========yum update=========="
systemctl restart network
yum update –y

echo "==========install openstack-packstack=========="
systemctl restart network
yum install -y openstack-packstack

echo "==========Generate answer file=========="
packstack --gen-answer-file answer.txt

sed -i -e 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=clock.stdtime.gov.tw/g' answer.txt
sed -i -e 's/CONFIG_HEAT_INSTALL=n/CONFIG_HEAT_INSTALL=y/g' answer.txt
sed -i -e 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' answer.txt
echo "=====================================\n
CONFIG_DEFAULT_PASSWORD={password}
CONFIG_KEYSTONE_ADMIN_PW={password}
\n====================================="

sleep 5
echo "==========Edit answer file=========="
vim answer.txt


echo "==========initial packstack=========="
sleep 3
systemctl restart network
packstack --answer-file ~/answer.txt

echo "==========end=========="


