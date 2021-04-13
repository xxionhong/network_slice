<p align="center">

# 下世代Network Slicing模組設計課程

This note is for the [:link:page](http://140.117.164.12/mbat_cctu/%E8%AA%B2%E5%A0%82%E6%95%99%E6%9D%90%E6%8A%95%E5%BD%B1%E7%89%87/)
***

</p>

## :point_right: Environment requirement
* ####  ubuntu &nbsp;&nbsp; [`20.04`](http://ftp.ubuntu-tw.org/ubuntu-releases/20.04.2.0/)
* ####  mininet &nbsp; [`2.3.0`](https://github.com/mininet/mininet)
* ####  ryu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [`v4.34 `](https://github.com/faucetsdn/ryu)

---

- [x] **[Experiment 1 :link:](./experiment_1/README.md)**
- [x] **[Experiment 2 :link:](./experiment_2/README.md)**
- [x] **[Experiment 3 :link:](./experiment_3/README.md)**
- [x] **[Experiment 4 :link:](./experiment_4/README.md)**

---

## Installation Guide
- ### Initialize ubuntu 

```bash
$ sudo apt-get update
$ sudo apt-get upgrade

# reboot
$ sudo reboot
```

- ### Install openvswitch

```bash
$ sudo apt install openvswitch-switch
```

- ### Check the openvswitch version

```bash
$ sudo ovs-vsctl -V
```

- ### Install mininet

```bash
# install git
$ sudo apt-get install -y git

# clone mininet
$ cd ~
$ git clone https://github.com/mininet/mininet

# install mininet and set as OpenFlow1.3
$ sudo ./mininet/util/install.sh -n3
```

- ### Check the mininet

```bash
$ sudo mn 

# leave mininet
$ exit
```

- ### Ryu Pre-install

```bash
$ sudo apt-get install -y libxml2-dev libxslt1-dev libffi-dev libssl-dev zlib1g-dev python3-pip python3-eventlet python3-routes python3-webob python3-paramiko gcc python3-dev 
$ sudo pip3 install msgpack-python eventlet==0.15.2
$ sudo pip3 install six --upgrade
$ sudo pip3 install oslo.config q --upgrade
```

- ### Install ryu

```bash
$ cd ~
$ git clone https://github.com/faucetsdn/ryu
$ cd ryu
$ sudo pip3 install .
$ cd ~
```

- ### Install Google-Chrome

```bash
$ cd Downloads/
$ wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
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
$ git clone https://github.com/THU-DBLAB/network_slice
```

- ### Optional

```bash
# remove openvswitch
$ sudo apt-get remove openvswitch-common openvswitch-switch openvswitch-pki openvswitch-testcontroller -y

# if ovs doesn't work, you can try this to start ovs
$ sudo /usr/share/openvswitch/scripts/ovs-ctl start
#or
$ sudo service openvswitch-switch restart
```

---

## Resources

- [:link: OpenFlow 1.3 Specification](https://opennetworking.org/wp-content/uploads/2014/10/openflow-spec-v1.3.0.pdf)
- [:link: SDNLAB](https://www.sdnlab.com/)
- [:link: Ryu Document](https://ryu.readthedocs.io/en/latest/index.html)
- [:link: Mininet Document](https://github.com/mininet/mininet/wiki/Documentation)
