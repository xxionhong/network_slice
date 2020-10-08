#!bin/bash

echo "==========create Private Network=========="
openstack network create net0
openstack subnet create net0 --network net0 \
--subnet-range 10.20.0.0/24 \
--gateway 10.20.0.254


echo "==========create Virtual Router=========="
openstack router create testRouter
openstack router set testRouter --external-gateway public
openstack router add subnet testRouter net0

echo "*****SELF*****"
echo " Web UI ** Project->Network->Security Group ** 
ALL ICMP Ingress/Egress
ALL TCP Ingress/Egress
ALL UDP Ingress/Egress"
echo "*****SELF*****"
echo "=====================================
openstack keypair create --public-key ~/.ssh/id_rsa.pub Demo
====================================="
echo "*****SELF*****"
echo "upload Image!!!!!"
echo "*****SELF*****"

echo "*****end*****"
