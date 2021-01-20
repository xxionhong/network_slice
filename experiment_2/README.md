<center>

# Experiment 2 

---

## :point_right: Task 1 - Ryu Topology Viewer

</center>

### `In Terminal`

```bash
# start the ryu-manager
# Gui topology with controller
$ cd ~
$ ryu-manager --verbose ryu/ryu/app/gui_topology/gui_topology.py ryu/ryu/app/simple_switch_13.py
```

```bash
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

:pushpin: Open http://127.0.0.1:8080 in browser, then you can see the Topology

|Topo_style|Description|Sample|
|---|----|--|
|<center>minimal (default)</center>|<center>Minimal topology with two hosts and one switch</center>|`sudo mn`|
|<center>linear</center>|<center>Linear topology of k switches, with one host per switch.</center>|`sudo mn --topo linear,k`|
|<center>reversed</center>|<center>Single switch connected to k hosts, with reversed ports.</center>|`sudo mn --topo reversed,k`|
|<center>single</center>|<center>Single switch connected to k hosts.</center>|`sudo mn --topo single,k`|
|<center>tree</center>|<center>Topology for a tree network with a given depth and fanout.</center>|`sudo mn --topo tree,n,k`|
|<center>torus</center>|<center>2-D Torus topology</center>|`sudo mn --topo torus,n,k`| 
---

<center>

## :point_right: Task 2 - With Custom Topology

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20task2.png?raw=true" width="500"/>
</p>

:white_medium_small_square: **task2_topo.py**

```python
from mininet.topo import Topo
from mininet.link import TCLink
class MyTopo(Topo):

    def __init__(self):
        Topo.__init__(self)

        h1 = self.addHost("h1")
        h2 = self.addHost("h2")
        h3 = self.addHost("h3")
        h4 = self.addHost("h4")
        s1 = self.addSwitch("s1")
        s2 = self.addSwitch("s2")

        self.addLink(h1,s1)
        self.addLink(h2,s1)
        self.addLink(h3,s1)
        self.addLink(s1,s2)
        self.addLink(h4,s2)

topos = {"mytopo":(lambda : MyTopo())}
```

### `In Terminal`

```bash
# start the ryu-manager
# with controller (simple_switch_13.py)
$ cd ~
$ ryu-manager --verbose ryu/ryu/app/gui_topology/gui_topology.py ryu/ryu/app/simple_switch_13.py
```

```bash
# start the mininet
$ cd ~
$ sudo mn --custom network_slice/experiment_2/task2_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

:pushpin: Open [http://127.0.0.1:8080 :link:](http://127.0.0.1:8080) in browser, then you can see the Topology

---

<center>

## :point_right: Task 3-1 - Modify Flows

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-13%20task3-1.png?raw=true" width="500"/>
</p>

### `In Terminal`

```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```

```bash
# mininet
$ sudo mn --topo single,4 --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20212446.jpg?raw=true" width="700"/>
</p>

### `In Terminal`

**Modify the flowentrys that make h1 and h4 can't ping each other**

```bash
# show the s1 flowentry
$ sudo ovs-ofctl -O OpenFlow13 dump-flows s1

$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth4", dl_src=00:00:00:00:00:04, dl_dst=00:00:00:00:00:01, actions=drop"
# mod the flow meets the match to set action=drop

$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth1", dl_src=00:00:00:00:00:01, dl_dst=00:00:00:00:00:04, actions=drop"
# mod the flow meets the match to set action=drop
```

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20213440.jpg?raw=true" width="700"/>
</p>

>### `Then pingall in mininet, it will show`
>`h1 -> h2 h3 x`
>`h2 -> h1 h3 h4`
>`h3 -> h1 h2 h4`
>`h4 -> x  h2 h3`

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20213533.jpg?raw=true" width="400"/>
</p>

---
<center>

## :point_right: Task 3-2 - Add Flows by command with restrict

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20task3.png?raw=true" width="600"/>
</p>

:white_medium_small_square: **task3_topo.py**

```python
from mininet.topo import Topo
from mininet.link import TCLink
class MyTopo(Topo):

    def __init__(self):
        Topo.__init__(self)

        h1 = self.addHost("h1")
        h2 = self.addHost("h2")
        h3 = self.addHost("h3")
        h4 = self.addHost("h4")
        s1 = self.addSwitch("s1")
        s2 = self.addSwitch("s2")
        s3 = self.addSwitch("s3")
        s4 = self.addSwitch("s4")

        self.addLink(s1,h1)
        self.addLink(s1,s2)
        self.addLink(s2,s4)
        self.addLink(s4,h3)

        self.addLink(s1,h2)
        self.addLink(s1,s3)
        self.addLink(s4,s3)
        self.addLink(s4,h4)
        
topos = {"mytopo":(lambda : MyTopo())}
```
### `In Terminal`

```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/ofctl_rest.py
```

```bash
# start the mininet
$ sudo mn --custom network_slice/experiment_2/task3_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

>### `Then pingall in mininet, it will show`
> `h1 -> x h3 x`
> `h2 -> x x h4`
> `h3 -> h1 x x`
> `h4 -> x h2 x`

:key: **Add the all flowentrys for s1, s2, s3, s4**

```bash
$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 in_port=1,actions=output:2
$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 in_port=2,actions=output:1
$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 in_port=3,actions=output:4
$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 in_port=4,actions=output:3
$ sudo ovs-ofctl -O OpenFlow13 add-flow s2 in_port=1,actions=output:2
$ sudo ovs-ofctl -O OpenFlow13 add-flow s2 in_port=2,actions=output:1
$ sudo ovs-ofctl -O OpenFlow13 add-flow s3 in_port=1,actions=output:2
$ sudo ovs-ofctl -O OpenFlow13 add-flow s3 in_port=2,actions=output:1
$ sudo ovs-ofctl -O OpenFlow13 add-flow s4 in_port=1,actions=output:2
$ sudo ovs-ofctl -O OpenFlow13 add-flow s4 in_port=2,actions=output:1
$ sudo ovs-ofctl -O OpenFlow13 add-flow s4 in_port=3,actions=output:4
$ sudo ovs-ofctl -O OpenFlow13 add-flow s4 in_port=4,actions=output:3
```

---

<center>

## :point_right: Task 4-1 - Meter Table

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20task2.png?raw=true" width="500"/>
</p>

[:pushpin: :link: Notice the OVS version and Linux kernel version when using meter](https://docs.openvswitch.org/en/latest/faq/releases/?highlight=meter%20linux%20kernel)

### `In Terminal`

```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```

```bash
# start the mininet
$ sudo mn --custom network_slice/experiment_2/task2_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

[:pushpin: :link: To use ovs-vswitchd in Userspace mode, set a switch with ```datapath_type=netdev``` in the configuration database (default ```datapath_type=system```) ](https://github.com/openvswitch/ovs/blob/master/Documentation/intro/install/userspace.rst)

```bash
$ sudo ovs-vsctl set bridge s1 datapath_type=netdev 
$ sudo ovs-vsctl set bridge s2 datapath_type=netdev 
```

### `In Mininet`

```bash
# open Xterm for h1 h2 h3 h4 in mininet 
$ xterm h1 h2 h3 h4
```

### `In Xterm h4`

:pushpin: When ```datapath_type``` is set to ```netdev```, the datapath is converted from ```Kernel mode``` to ```Userspace mode```, datapath receives the packet arrives, the packet will be checked and the packet will be discarded if the check fails. 
This is why in many cases, after ```datapath_type=netdev```, **the hosts can be ping through, but the ```iperf``` cannot be used to measure bandwidth**. Need to turn off ```tx-checksumming```.

```bash
# turn off the tx-checksumming
$ ethtool -K h4-eth0 tx off
$ iperf -s
```

### `In Xterm h1`

```bash
# turn off the tx-checksumming
$ ethtool -K h1-eth0 tx off
$ iperf -c 10.0.0.4
```

### `In Xterm h2`

```bash
# turn off the tx-checksumming
$ ethtool -K h2-eth0 tx off
$ iperf -c 10.0.0.4
```

### `In Xterm h3`

```bash
# turn off the tx-checksumming
$ ethtool -K h3-eth0 tx off
$ iperf -c 10.0.0.4
```

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20214623.jpg?raw=true" width="700"/>
</p>

### `In Terminal`

```bash
# add meter
$ sudo ovs-ofctl -O OpenFlow13 add-meter s1 meter=1,kbps,band=type=drop,rate=5000
# 5000 kbps = 5 Mbps

# show meters
$ sudo ovs-ofctl -O OpenFlow13 dump-meters s1

# show flowentrys in terminal
$ sudo ovs-ofctl -O OpenFlow13 dump-flows s1

# modify the flowentry meet the match, set action into meter then outport 
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth1", dl_src=00:00:00:00:00:01, dl_dst=00:00:00:00:00:04, actions=meter:1,output:"s1-eth4""
```

### `In Xterm h1`

```bash
# check the different 
$ iperf -c 10.0.0.4
```

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20215010.jpg?raw=true" width="700"/>
</p>

### `Optional, In Terminal`

```bash
# delete meter 
$ sudo ovs-ofctl -O OpenFlow13 del-meter s1 meter=1
```

[:link:Relate page](https://www.sdnlab.com/24306.html)

---

<center>

## :point_right: Task 4-2 - Flowentry Design

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20task4-2.png?raw=true" width="500"/>
</p>

:white_medium_small_square: **task4_topo.py**

```python
from mininet.topo import Topo
from mininet.link import TCLink
class MyTopo(Topo):

    def __init__(self):
        Topo.__init__(self)

        h1 = self.addHost("h1")
        h2 = self.addHost("h2")
        h3 = self.addHost("h3")

        s1 = self.addSwitch("s1")
        s2 = self.addSwitch("s2")
        s3 = self.addSwitch("s3")

        self.addLink(h1,s1,cls=TCLink,bw=100) # bw=Mbps
        self.addLink(h2,s2,cls=TCLink,bw=100)
        self.addLink(h3,s3,cls=TCLink,bw=100)
        self.addLink(s1,s2,cls=TCLink,bw=10)
        self.addLink(s1,s3,cls=TCLink,bw=100)
        self.addLink(s2,s3,cls=TCLink,bw=100)
        
topos = {"mytopo":(lambda : MyTopo())}
```

[:link: Mininet config function source code](https://github.com/mininet/mininet/blob/de28f67a97fc8915cc1586c984465d89a016d8eb/mininet/link.py#L314)

### `In Terminal`
```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/ofctl_rest.py
```

```bash
# start the mininet
$ sudo mn --custom network_slice/experiment_2/task4_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```

:key: **Add flowentrys to s1, s2, s3**

```bash
$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 table=0,in_port=1,actions=output:3
# in s1, from port1(h1) to port3(s2)

$ sudo ovs-ofctl -O OpenFlow13 add-flow s1 table=0,in_port=3,actions=output:1
# in s1, from port3(s2)  to port1(h1)

$ sudo ovs-ofctl -O OpenFlow13 add-flow s2 table=0,in_port=1,actions=output:3
# in s2, from port1(h2)  to port3(s3)

$ sudo ovs-ofctl -O OpenFlow13 add-flow s2 table=0,in_port=3,actions=output:1
# in s2, from port3(s3)  to port1(h2)

$ sudo ovs-ofctl -O OpenFlow13 add-flow s3 table=0,in_port=3,actions=output:2
# in s3, from port3(s2)  to port2(s1)

$ sudo ovs-ofctl -O OpenFlow13 add-flow s3 table=0,in_port=2,actions=output:3
# in s3, from port2(s1)  to port3(s2)
```
### `In Mininet`

```bash
# open Xterm for h1 h2 in mininet 
$ xterm h1 h2
```

### `Xterm h1`

```bash
# open iperf
$ iperf -s
```

### `Xterm h2`

```bash
# open iperf
$ iperf -c 10.0.0.1 -i 2
```

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20221620.jpg?raw=true" width="700"/>
</p>

:pushpin: **Transmission Bandwidth between h1 and h2 does not restrict in 10Mbps.**