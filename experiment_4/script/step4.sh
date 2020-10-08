#!bin/bash

echo "create tacker DB\n
=====================================
mysql -uroot
CREATE DATABASE tacker;
grant all privileges on tacker.* to 'tacker'@'%' identified by '{pwd}';
grant all privileges on tacker.* to 'tacker'@'127.0.0.1' identified by '{pwd}';
flush privileges;
exit
\n====================================="

echo "Create Openstack User"
cd ~
echo "=====================================\n
source ~/keystonerc_admin
\n====================================="

echo "=====================================\n
openstack user create --domain default --password {pwd} tacker
openstack role add --project services --user tacker admin
\n====================================="

echo "Create Service
=====================================\n
openstack service create --name tacker --description "Tacker Project" nfv-orchestration
\n====================================="

ip="$(hostname -i)"
echo "$ip"

echo "
=====================================\n
openstack endpoint create --region RegionOne nfv-orchestration public http://{ip}:9890/
openstack endpoint create --region RegionOne nfv-orchestration internal http://{ip}:9890/
openstack endpoint create --region RegionOne nfv-orchestration admin http://{ip}:9890/
\n=====================================
"
echo "*****end*****"


