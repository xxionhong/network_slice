<center>

# Experiment 3 - QoS

</center>
---

```bash
# ryu
$ ryu-manager --verbose ryu/ryu/app/simple_switch_13.py
```
```bash
# mininet
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
### `In Terminal`
```bash
# set Qos for Port s1-eth4 with 3 queues (q0 q1 q2),Qos Type is linux-htb
$ sudo ovs-vsctl -- set Port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb queues:0=@q0 queues:1=@q1 queues:2=@q2 -- \
--id=@q0 create Queue other-config:max-rate=9000000 -- \
--id=@q1 create Queue other-config:max-rate=6000000 -- \
--id=@q2 create Queue other-config:max-rate=3000000

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

# mod the flows to different queue (q0 q1 q2)
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
    <img src="https://github.com/xxionhong/network_slice/blob/main/experiment_3/img/2020-10-15%20215853.jpg?raw=true" width="700"/>
</p>

### `Optional, In Terminal`
```bash
# kill all Qos and Queue
$ sudo ovs-vsctl -- --all destroy QoS -- --all destroy Queue
# kill single qos and queue
$ sudo ovs-vsctl remove qos {uuid} queue {queue_num}
$ sudo ovs-vsctl destroy queue {uuid}
```
```bash
# Weighted Round Robin (example)
$ sudo ovs-vsctl -- set port s1-eth4 qos=@newqos -- \
--id=@newqos create qos type=PRONTO_WEIGHTED_ROUND_ROBIN queues:0=@newqueue queues:3=@newqueue1 -- \
--id=@newqueue create queue other-config=min-rate=200000000,weight=3  -- \
--id=@newqueue1 create queue other-config=min-rate=200000000,weight=3  
```

#### [Relate page :link:](https://www.sdnlab.com/23289.html)