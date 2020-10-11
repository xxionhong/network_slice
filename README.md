# 下世代Network Slicing模組設計課程

* _This note is for the [page](http://140.117.164.12/mbat_cctu/%E8%AA%B2%E5%A0%82%E6%95%99%E6%9D%90%E6%8A%95%E5%BD%B1%E7%89%87/)_
***
## Environment requirement
* ubuntu &nbsp;`16.04`
* mininet `2.3.0d6 (master)`
* ryu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`v4.34 (master)`
***
## Installation Guile

### Initialize ubuntu 

```shell
$ sudo apt-get update
$ sudo apt-get upgrade

# install git
$ sudo apt-get install -y git

# reboot
$ sudo reboot
```

### Install mininet
```shell
# clone mininet
$ cd ~
$ it clone git://github.com/mininet/mininet

# modify the mininet's install.sh script
$ sed -i -e 's/for pkg in/$pkginst libopenvswitch_$OVS_RELEASE*.deb\n    for pkg in/g' ~/mininet/util/install.sh

# install mininet and ovs 2.10.5
$ sudo ./mininet/util/install.sh -n3V 2.10.5
```
### Check the openvswitch version
```shell
$ sudo ovs-vsctl -V
```

### Check the mininet
```shell
$ sudo mn 

# leave mininet
$ exit
```

### Before install ryu
```shell
$ sudo apt-get install -y libxml2-dev libxslt1-dev libffi-dev libssl-dev zlib1g-dev python3-pip python-eventlet python-routes python-webob python-paramiko gcc python-dev 
$ sudo pip3 install msgpack-python eventlet==0.15.2
$ sudo pip3 install six --upgrade
$ sudo pip3 install oslo.config q --upgrade
```

### Install ryu
```shell
$ cd ~
$ git clone https://github.com/faucetsdn/ryu.git
$ cd ryu
$ sudo pip3 install .
$ cd ~
```

### Install Google-Chrome
```shell
$ cd Downloads/
$ wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
$ sudo apt-get install -f
$ cd ~
```