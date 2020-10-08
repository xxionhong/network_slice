#!/bin/bash
echo "==========停用防火牆=========="
systemctl stop firewalld NetworkManager
systemctl disable firewalld NetworkManager

echo "==========停用selinux=========="
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i -e 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config

echo "==========mod the repo=========="
sed -i -e 's/#baseurl/baseurl/g' /etc/yum.repos.d/CentOS-Base.repo

echo "==========restart network=========="
systemctl restart network

echo "==========Update and Reboot=========="
yum update –y

sleep 5
reboot

echo "==========end=========="
