```bash
# Stop the Firewalld=========
$ systemctl stop firewalld NetworkManager
$ systemctl disable firewalld NetworkManager

# Stop selinux
$ setenforce 0
$ sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
$ sed -i -e 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config

# restart network
$ systemctl restart network

# Update and Reboot
$ yum update
$ reboot
```

```bash
$ git clone https://github.com/xxionhong/network_slice

# check SELINUX
$ sestatus
# should show: SELinux status:                 disabled

# install centos-release-openstack-train
$ yum install -y centos-release-openstack-train

# yum update
$ yum update –y

# install openstack-packstack
$ yum install -y openstack-packstack

# Generate answer file
$ packstack --gen-answer-file answer.txt

$ sed -i -e 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=clock.stdtime.gov.tw/g' answer.txt
$ sed -i -e 's/CONFIG_HEAT_INSTALL=n/CONFIG_HEAT_INSTALL=y/g' answer.txt
$ sed -i -e 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' answer.txt

# Edit answer file
$ vim answer.txt
# ===========================
# CONFIG_DEFAULT_PASSWORD={password}
# CONFIG_KEYSTONE_ADMIN_PW={password}
# ===========================

# initial packstack
$ packstack --answer-file ~/answer.txt
# it may take half hour...
```

```bash
# backup ifcfg-enp0s3
$ mv /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/ifcfg-enp0s3.bak

# move ifcfg-enp0s3 and ifcfg-br-ex
$ cp network_slice/experiment_4/script/ifcfg-enp0s3 /etc/sysconfig/network-scripts/
$ cp network_slice/experiment_4/script/ifcfg-br-ex /etc/sysconfig/network-scripts/

# chmod 744 ifcfg-enp0s3 and ifcfg-br-ex
$ chmod 744 /etc/sysconfig/network-scripts/ifcfg-enp0s3
$ chmod 744 /etc/sysconfig/network-scripts/ifcfg-br-ex

# show the ip
$ hostname -i

# edit br-ex
$ vim /etc/sysconfig/network-scripts/ifcfg-br-ex

# restart network
$ systemctl restart network

# show ovs-vsctl
$ ovs-vsctl show
```

```bash
# create tacker DB
$ mysql -uroot
$ CREATE DATABASE tacker;
$ grant all privileges on tacker.* to 'tacker'@'%' identified by '{pwd}';
$ grant all privileges on tacker.* to 'tacker'@'127.0.0.1' identified by '{pwd}';
$ flush privileges;
$ exit

# Create Openstack User"
$ cd ~
$ source ~/keystonerc_admin
$ openstack user create --domain default --password {pwd} tacker
$ openstack role add --project services --user tacker admin

# Create Service
$ openstack service create --name tacker --description "Tacker Project" nfv-orchestration

$ hostname -i

# 
$ openstack endpoint create --region RegionOne nfv-orchestration public http://{ip}:9890/
$ openstack endpoint create --region RegionOne nfv-orchestration internal http://{ip}:9890/
$ openstack endpoint create --region RegionOne nfv-orchestration admin http://{ip}:9890/
```

```bash
# install tackerclient
$ yum install –y python2-tackerclient 
$ yum install -y openstack-tacker 
```

```bash
# replace tacker.conf
$ mv /etc/tacker/tacker.conf /etc/tacker/tacker.conf.bak
$ cp script/tacker.conf /etc/tacker/
$ chmod 744 /etc/tacker/tacker.conf

$ hostname -i

$ vim /etc/tacker/tacker.conf

# upgrade tacker-DB
$ /usr/bin/tacker-db-manage --config-file /etc/tacker/tacker.conf upgrade head

# download and install tacker-horizon
$ cd ~
$ git clone https://github.com/openstack/tacker-horizon.git -b stable/train
$ cd tacker-horizon
$ python setup.py install

# Enable tacker dashboard
$ cp tacker_horizon/enabled/_80_nfv.py /usr/share/openstack-dashboard/openstack_dashboard/enabled/

# restart httpd and openstack
$ systemctl restart httpd

# restart openstack-tacker-server
$ systemctl restart openstack-tacker-server

# restart openstack-tacker-conductor 
$ systemctl restart openstack-tacker-conductor

# enable openstack-tacker-server openstack-tacker-conductor
$ systemctl enable openstack-tacker-server openstack-tacker-conductor

# mkdir and chmod
$ mkdir -p /etc/tacker/vim/fernet_keys
$ chown tacker:tacker /etc/tacker/* -R
```

```bash
# replace config.yaml
$ cp script/config.yaml /etc/tacker/
$ chmod 744 /etc/tacker/config.yaml

$ hostname -i

# vim admin-openrc.sh
$ vim script/admin-openrc.sh
$ source script/admin-openrc.sh

# vim config.yaml
$ vim /etc/tacker/config.yaml

# create vim in openstack
$ openstack vim register --config-file /etc/tacker/config.yaml --description 'my first vim' --is-default Hello-VIM
```

```bash
# use Tacker to create VNF
$ source keystonerc_admin


$ openstack network create --share --external \
--provider-physical-network extnet \
--provider-network-type flat public


$ openstack subnet create --network public \
--allocation-pool start=192.168.0.20,end=192.168.0.40 \
--gateway 192.168.0.1 \
--subnet-range 192.168.0.0/24 public

```

```bash
# create Private Network
$ openstack network create net0
$ openstack subnet create net0 --network net0 \
--subnet-range 10.20.0.0/24 \
--gateway 10.20.0.254


# create Virtual Router
$ openstack router create testRouter
$ openstack router set testRouter --external-gateway public
$ openstack router add subnet testRouter net0

# Web UI ** Project->Network->Security Group ** 
# ALL ICMP Ingress/Egress
# ALL TCP Ingress/Egress
# ALL UDP Ingress/Egress"

$ openstack keypair create --public-key ~/.ssh/id_rsa.pub Demo

# upload Image!!!!!"
```
```bash
# Create Vnfd
# https://docs.openstack.org/tacker/latest/user/vnfm_usage_guide.html
$ openstack vnf descriptor create --vnfd-file script/Vnfd.yaml vnfd

# Create VNF

$ openstack vnf create --vnfd-name vnfd server
```
