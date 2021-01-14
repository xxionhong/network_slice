<center>

# Experiment 3 - QoS

</center>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_2/img/2021-01-09%20task2.png?raw=true" width="500"/>
</p>

### `In Terminal`

```bash
# start the ryu-manager
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```
```bash
# start the mininet
$ sudo mn --custom network_slice/experiment_3/exp3_topo.py --topo mytopo --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Mininet`
```bash
# open Xterm for h1 h2 h3 h4 in mininet 
$ xterm h1 h2 h3 h4
```
### `In Xterm h4`
```bash
# in h4
$ iperf -s
```
### `In Xterm h1 h2 h3`
```bash
# in h1 h2 h3
$ iperf -c 10.0.0.4
```
 :pushpin: **To see the transmission bandwidth from h1, h2, h3 to h4 before we set the Qos parameter.**
### `In Terminal`
```bash
# set Qos for Port s1-eth4 with 3 queues (q0 q1 q2),Qos Type is linux-htb
$ sudo ovs-vsctl -- set Port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb queues:0=@q0 queues:1=@q1 queues:2=@q2 -- \
--id=@q0 create Queue other-config:max-rate=9000000 -- \
--id=@q1 create Queue other-config:max-rate=6000000 -- \
--id=@q2 create Queue other-config:max-rate=3000000
# 9000000 = 9 Mb, 6000000 = 6 Mb, 3000000 = 3 Mb

# show the port s1-eth4 detail
$ sudo ovs-vsctl list port s1-eth4

# show the qos
$ sudo ovs-vsctl list qos {uuid}
# or
$ sudo ovs-appctl qos/show s1-eth4

# show the queue
$ sudo ovs-vsctl list queue {uuid}

# show the flowentry in s1
$ sudo ovs-ofctl -O openflow13 dump-flows s1

# modify the flowentry meet the match set action to different queue (q0 q1 q2)
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth1", dl_src=00:00:00:00:00:01, dl_dst=00:00:00:00:00:04, actions=set_queue:0,output:"s1-eth4""
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth2", dl_src=00:00:00:00:00:02, dl_dst=00:00:00:00:00:04, actions=set_queue:1,output:"s1-eth4""
$ sudo ovs-ofctl -O OpenFlow13 mod-flows s1 "table=0, priority=1, in_port="s1-eth3", dl_src=00:00:00:00:00:03, dl_dst=00:00:00:00:00:04, actions=set_queue:2,output:"s1-eth4""
```
### `In Xterm h1 h2 h3`
```bash
# in h1 h2 h3 to check the different
$ iperf -c 10.0.0.4
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_3/img/2020-10-15%20215853.jpg?raw=true" width="700"/>
</p>
 
 :pushpin: **The transmission bandwidth is restrict in the queue max rate.**

### `Optional, In Terminal`
```bash
# kill all Qos and Queue
$ sudo ovs-vsctl -- --all destroy QoS -- --all destroy Queue
# kill single qos and queue
$ sudo ovs-vsctl remove qos {uuid} queue {queue_num}
$ sudo ovs-vsctl destroy queue {uuid}
```
:pushpin: OVS does not Support yet

```bash
# Round Robin (example)
$ sudo ovs-vsctl -- set Port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=PRONTO_ROUND_ROBIN queues:0=@q0 queues:1=@q1 queues:2=@q2 -- \
--id=@q0 create Queue other-config:min-rate=100000000 other-config:max-rate=200000000 -- \
--id=@q1 create Queue other-config:min-rate=200000000 other-config:max-rate=400000000 -- \
--id=@q2 create Queue other-config:min-rate=400000000 other-config:max-rate=600000000
```

```bash
# Weighted Round Robin (example)
$ sudo ovs-vsctl -- set Port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=PRONTO_WEIGHTED_ROUND_ROBIN queues:0=@q0 queues:1=@q1 queues:2=@q2 -- \
--id=@q0 create Queue other-config=max-rate=300000000,weight=5 -- \
--id=@q1 create Queue other-config=max-rate=200000000,weight=3 -- \
--id=@q2 create Queue other-config=max-rate=100000000,weight=1
```

```bash
# Weighted Fair Queuing (example)
$ sudo ovs-vsctl -- set Port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=PRONTO_WEIGHTED_FAIR_QUEUING queues:0=@q0 queues:1=@q1 queues:2=@q2 -- \
--id=@q0 create Queue other-config=max-rate=300000000,weight=5 -- \
--id=@q1 create Queue other-config=max-rate=200000000,weight=3 -- \
--id=@q2 create Queue other-config=max-rate=100000000,weight=1
```

- **[PICA8 Configuring QoS scheduler :link:](https://docs.pica8.com/display/PicOS211sp/Configuring+QoS+scheduler)**
- **[基於Open vSwitch的傳統限速和SDN限速:link:](https://www.sdnlab.com/23289.html)**
- **[Open vSwitch之QoS的實現 :link:](https://www.sdnlab.com/19208.html)**
- **[OVS QoS流量控制 (DPDK):link:](https://blog.csdn.net/sinat_20184565/article/details/93376574)**