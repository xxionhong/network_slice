# 下世代Network Slicing模組設計課程

* This note is for the [page:link:](http://140.117.164.12/mbat_cctu/%E8%AA%B2%E5%A0%82%E6%95%99%E6%9D%90%E6%8A%95%E5%BD%B1%E7%89%87/)
***
## :point_right: Environment requirement
* #### ubuntu &nbsp;`18.04`
* #### mininet `2.3.0d6`
* #### ryu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`v4.34 `
---
- [x] **[Experiment 1 :link:](./experiment_1/README.md)**
- [x] **[Experiment 2 :link:](./experiment_2/README.md)**
- [x] **[Experiment 3 :link:](./experiment_3/README.md)**
- [x] **[Experiment 4 :link:](./experiment_4/script/README.md)**
---
## Installation Guile
- ### Initialize ubuntu 

```bash
$ sudo apt-get update
$ sudo apt-get upgrade

# install git
$ sudo apt-get install -y git

# reboot
$ sudo reboot
```

- ### Install mininet
```bash
# clone mininet
$ cd ~
$ git clone git://github.com/mininet/mininet

# modify the mininet's install.sh script
$ sed -i -e 's/for pkg in/$pkginst libopenvswitch_$OVS_RELEASE*.deb\n    for pkg in/g' ~/mininet/util/install.sh

# install mininet and openvswitch 2.10.5
$ sudo ./mininet/util/install.sh -n3V 2.10.5
```
- ### Check the openvswitch version
```bash
$ sudo ovs-vsctl -V
```

- ### Check the mininet
```bash
$ sudo mn 

# leave mininet
$ exit
```

- ### Ryu Pre-install
```bash
$ sudo apt-get install -y libxml2-dev libxslt1-dev libffi-dev libssl-dev zlib1g-dev python3-pip python-eventlet python-routes python-webob python-paramiko gcc python-dev 
$ sudo pip3 install msgpack-python eventlet==0.15.2
$ sudo pip3 install six --upgrade
$ sudo pip3 install oslo.config q --upgrade
```

- ### Install ryu
```bash
$ cd ~
$ git clone https://github.com/faucetsdn/ryu.git
$ cd ryu
$ sudo pip3 install .
$ cd ~
```

- ### Install Google-Chrome
```bash
$ cd Downloads/
$ wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
$ sudo apt-get install -f
$ cd ~
```

- ### Install Postman on Google-Chrome
[:link: Tabbed Postman - REST Client ](https://chrome.google.com/webstore/detail/tabbed-postman-rest-clien/coohjcphdfgbiolnekdpbcijmhambjff?hl=zh-TW)

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/img/2021-01-13%20postman.png?raw=true" width="500"/>
</p>

- ### Clone this Github page
```bash
$ cd ~
$ git clone https://github.com/xxionhong/network_slice.git
```
- ### Optional
```bash
# remove old-ovs
$ sudo apt-get remove openvswitch-common openvswitch-switch openvswitch-pki openvswitch-testcontroller -y

# if ovs doesn't work, you can try this.
$ sudo /usr/share/openvswitch/scripts/ovs-ctl start
```
---

## Resources
- [:link: OpenFlow 1.3 Specification](https://opennetworking.org/wp-content/uploads/2014/10/openflow-spec-v1.3.0.pdf)
- [:link: SDNLAB](https://www.sdnlab.com/)
- [:link: Ryu Document](https://ryu.readthedocs.io/en/latest/index.html)
- [:link: Mininet Document](https://github.com/mininet/mininet/wiki/Documentation)
