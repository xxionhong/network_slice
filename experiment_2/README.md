# Experiment 2
---
- ## Task 1
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
Go Browser, open http://127.0.0.1:8080, then we can see the Topology
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20211848.jpg?raw=true" width="700"/>
</p>

---
- ## Task 2
- - #### task2_topo.py
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
Go Browser, open http://127.0.0.1:8080, then we can see the Topology
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20212222.jpg?raw=true" width="700"/>
</p>

---
- ## Task 3
```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```
```bash
# mininet
$ sudo mn --topo single,4 --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20212446.jpg?raw=true" width="700"/>
</p>

### `In Terminal`
```bash
# show the s1 flowentry
$ sudo ovs-ofctl -O OpenFlow13 dump-flows s1

# then mod the flows that make h1 and h4 can't ping each other
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth4", dl_src=00.00.00.00.00.04, dl_dst=00.00.00.00.00.01, actions=drop"
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth1", dl_src=00.00.00.00.00.01, dl_dst=00.00.00.00.00.04, actions=drop"
```
<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20213440.jpg?raw=true" width="700"/>
</p>

>### `Then pingall in mininet, it will show`
> `h1 -> h2 h3 x`
> `h2 -> h1 h3 h4`
> `h3 -> h1 h2 h4`
> `h4 -> x  h2 h3`

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20213533.jpg?raw=true" width="500"/>
</p>

---
- ## Task 4-1


```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```
```bash
# mininet
$ sudo mn --custom network_slice/experiment_2/task2_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Terminal`
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
```bash
$ ethtool -K h4-eth0 tx off
$ iperf -s
```
### `In Xterm h1`
```bash
$ ethtool -K h1-eth0 tx off
$ iperf -c 10.0.0.4
```
### `In Xterm h2`

```bash
$ ethtool -K h2-eth0 tx off
$ iperf -c 10.0.0.4
```
### `In Xterm h3`

```bash
$ ethtool -K h3-eth0 tx off
$ iperf -c 10.0.0.4
```

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20214623.jpg?raw=true" width="700"/>
</p>

### `In Terminal`
```bash
# add meter
$ sudo ovs-ofctl -O OpenFlow13 add-meter s1 meter=1,kbps,band=type=drop,rate=5000
# 5000 kbps = 5 Mbps

# show meters
$ sudo ovs-ofctl -O OpenFlow13 dump-meters s1

# show flows in terminal
$ sudo ovs-ofctl -O OpenFlow13 dump-flows s1

# mod flowentry into meter 
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth1", dl_src=00.00.00.00.00.01, dl_dst=00.00.00.00.00.04, actions=meter:1,output:"s1-eth4""
```
### `In Xterm h1`
```bash
# check the different 
$ iperf -c 10.0.0.4
```

<p align="center">
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2020-10-15%20215010.jpg?raw=true" width="700"/>
</p>
### `Optional, In Terminal`
```bash
# delete meter 
$ sudo ovs-ofctl -O OpenFlow13 del-meter s1 meter=1
```
#### [Relate page](https://www.sdnlab.com/24306.html)
---
- ## ~~Task 4-2~~ 
- - #### task4_topo.py
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

        self.addLink(h1,s1,cls=TCLink,bw=100)
        self.addLink(h2,s2,cls=TCLink,bw=100)
        self.addLink(h3,s3,cls=TCLink,bw=100)
        self.addLink(s1,s2,cls=TCLink,bw=10)
        self.addLink(s1,s3,cls=TCLink,bw=100)
        self.addLink(s2,s3,cls=TCLink,bw=100)
        
topos = {"mytopo":(lambda : MyTopo())}
```
```bash
# ryu
$ ryu-manager --verbose ryu/ryu/app/ofctl_rest.py
```
```bash
# mininet
$ sudo mn --custom network_slice/experiment_2/task4_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
#### Using restful way (Postman) to add-flow for the switch. 
### [ofctl_rest page](https://ryu.readthedocs.io/en/latest/app/ofctl_rest.html)
### `In Postman`
#### `http://127.0.0.1:8080/stats/flowentry/add`
#### `POST/json`

```json
# Flow in s1 (h1 to h2 and h3)=
{
    "dpid":1,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":1},  
    "actions":[{  "type":"OUTPUT",  "port":3}]
}
```
```json
#Flow in s1 (h2 and h3 and h1)=
{
    "dpid":1,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":3},  
    "actions":[{  "type":"OUTPUT",  "port":1}]
}
```
```json
# Flow in s2 (h2 to h3 and h1)=
{
    "dpid":2,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":1},  
    "actions":[{  "type":"OUTPUT",  "port":3}]
}
```
```json
# Flow in s2 (h1 and h3 to h2)=
{
    "dpid":2,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":3},  
    "actions":[{  "type":"OUTPUT",  "port":1}]
}
```
```json
# Flow in s3 (h1 to h2)=
{
    "dpid":3,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":2},  
    "actions":[{  "type":"OUTPUT",  "port":3}]
}
```
```json
# Flow in s3 (h2 to h1)=
{
    "dpid":3,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"in_port":3},  
    "actions":[{  "type":"OUTPUT",  "port":2}]
}
```