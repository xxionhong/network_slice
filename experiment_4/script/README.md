- # OpenStack Tacker installation
---
## Environment requirement
* ###### CentOS-7 &nbsp;`2009`
* ###### OpenStack `train`
* ###### Tacker &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`stable/train`
* ###### Oracle VirtualBox
* ###### Wired Network (Do not use Wi-Fi)
---
- ## VirtualBox Network Setting
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-12%20154259.jpg?raw=true" width="500"/>
</p>

---
- ## CentOS7 installation Network Setting
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-12%20154043.jpg?raw=true" width="500"/>
</p>

---
- ## Disable firewall, SELINUX and update
```bash
# login as root
$ cd ~
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
$ yum update -y
$ reboot
```
- ## Install openstack-train
```bash
$ yum install -y git 
$ cd ~
$ git clone https://github.com/xxionhong/network_slice

# check SELINUX
$ sestatus
# should show: SELinux status:                 disabled

# install centos-release-openstack-train
$ yum install centos-release-openstack-train -y

# yum update
$ yum update -y

# install openstack-packstack
$ yum install openstack-packstack -y

# Generate answer file
$ packstack --gen-answer-file answer.txt

# mod the answer.txt file
# CONFIG_DEFAULT_PASSWORD={password}
# CONFIG_NTP_SERVERS=clock.stdtime.gov.tw
# CONFIG_KEYSTONE_ADMIN_PW={password}
# CONFIG_HEAT_INSTALL=y
# CONFIG_PROVISION_DEMO=n

# Edit answer file
$ sed -i -e 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=clock.stdtime.gov.tw/g' answer.txt
$ sed -i -e 's/CONFIG_HEAT_INSTALL=n/CONFIG_HEAT_INSTALL=y/g' answer.txt
$ sed -i -e 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' answer.txt
$ vim answer.txt

# initial packstack
$ packstack --answer-file answer.txt
# it may take half hour...
```
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-12%20162337.jpg?raw=true" width="700"/>
</p>
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-15%20152401.jpg?raw=true" width="1000"/>
</p>
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-15%20152435.jpg?raw=true" width="1000"/>
</p>

---
- - ### ifcfg-br-ex
```txt
IPADDR={Host IP}
GATEWAY={GW IP}
ONBOOT=yes
PREFIX=24
DNS1=8.8.8.8
DEVICE=br-ex
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
```
- - ### ifcfg-enp0s3
```txt
DEVICE=enp0s3
TYPE=OVSPort
DEVICETYPE=ovs
OVS_BRIDGE=br-ex
ONBOOT=yes
```
- ## Modify the network-script
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
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20141330.jpg?raw=true" width="350"/>
</p>

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

# create openstack endpoint
$ openstack endpoint create --region RegionOne nfv-orchestration public http://{ip}:9890/
$ openstack endpoint create --region RegionOne nfv-orchestration internal http://{ip}:9890/
$ openstack endpoint create --region RegionOne nfv-orchestration admin http://{ip}:9890/
```
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20142353.jpg?raw=true" width="700"/>
</p>

---
- ## Install tacker
- - ### tacker.conf
```txt
[default]
auth_strategy = keystone
policy_file = /etc/tacker/policy.json
debug = True
use_syslog = False
bind_host = {IP}
bind_port = 9890
service_plugins = nfvo,vnfm
state_path = /var/lib/tacker
transport_url = rabbit://openstack:{PASSWORD}@{IP}
[keystone_authtoken]
www_authenticate_uri = http://{IP}:5000
auth_url = http://{IP}:5000
memcached_servers = {IP}:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = services
username = tacker
password = {PASSWORD}
token_cache_time = 3600
[database]
connection = mysql+pymysql://tacker:{PASSWORD}@{IP}/tacker
[nfvo_vim]
vim_drivers = openstack
[tacker]
monitor_driver = ping,http_ping
```
```bash
# install tackerclient
$ yum install python2-tackerclient -y
$ yum install openstack-tacker -y

# replace tacker.conf
$ mv /etc/tacker/tacker.conf /etc/tacker/tacker.conf.bak
$ cp network_slice/experiment_4/script/tacker.conf /etc/tacker/
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
- - ### config.yaml
```txt
auth_url: 'http://{IP}:5000/v3'
username: 'admin'
password: '{pw}'
project_name: 'admin'
project_domain_name: 'Default'
user_domain_name: 'Default'
cert_verify: 'True'
```
```bash
# replace config.yaml
$ cd ~
$ cp network_slice/experiment_4/script/config.yaml /etc/tacker/
$ chmod 744 /etc/tacker/config.yaml

$ hostname -i

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
```

- ### Add the ICMP, TCP ,UDP Ingress/Engress Security Group

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-15%20154355.jpg?raw=true" width="900"/>
</p>

- ### Upload the ubuntu Image

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20143042.jpg?raw=true" width="900"/>
</p>

---

```bash
# Create Vnfd
# https://docs.openstack.org/tacker/latest/user/vnfm_usage_guide.html
$ openstack vnf descriptor create --vnfd-file network_slice/experiment_4/script/Vnfd.yaml vnfd

# Create VNF
$ openstack vnf create --vnfd-name vnfd server
```

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20143258.jpg?raw=true" width="900"/>
</p>

- ### Mount the float IP

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20143502.jpg?raw=true" width="900"/>
</p>

- #### then you can access `ssh ubuntu@{float-ip}` to login vnf
fd
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_4/img/2020-10-16%20143638.jpg?raw=true" width="700"/>
</p>