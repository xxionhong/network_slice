<p align="center">

# Experiment 1
</p>

---
<p align="center">

## :point_right: Task 1 - Using ryu and mininet with restful api 

</p>

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/THU-DBLAB/network_slice/blob/main/experiment_1/img/2021-04-13-add.png?raw=true" width="400"/>
</p>

### `In Terminal`

```bash
# start the ryu-manager
$ sudo ryu-manager --verbose ryu.app.ofctl_rest
```
```bash
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
#### :pushpin: Use restful way (Postman) to add-flow for the switch. 
##### [:link: ofctl_rest Document ](https://ryu.readthedocs.io/en/latest/app/ofctl_rest.html)
### `In Postman`
#### `http://127.0.0.1:8080/stats/flowentry/add`
#### `POST/json`
```json
# Flow1 (h1->h2)=
{
    "dpid":1,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"dl_dst":"00:00:00:00:00:02"},  
    "actions":[{  "type":"OUTPUT",  "port":2}]
}
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20205313.jpg?raw=true" width="400"/>
</p>

```json
# Flow2 (h2->h1)=
{
    "dpid":1,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"dl_dst":"00:00:00:00:00:01"},  
    "actions":[{  "type":"OUTPUT",  "port":1}]
}
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20205410.jpg?raw=true" width="400"/>
</p>

```json
# Flow3 (ARP)=
{
    "dpid":1,  
    "cookie":1,  
    "cookie_mask":1,  
    "table_id":0,   
    "priority":1,  
    "flags":1,  
    "match":{"dl_type":2054,"arp_tpa":"10.0.0.2"},  
    "actions":[{  "type":"OUTPUT",  "port":2}]
}
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20205459.jpg?raw=true" width="400"/>
</p>

[:pushpin::link: EtherType](https://en.wikipedia.org/wiki/EtherType)

### `In Terminal`
```bash
# show the flowentrys in s1
$ sudo ovs-ofctl -O openflow13 dump-flows s1

# show the hidden flowentrys in s1
$ sudo ovs-appctl bridge/dump-flows s1
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20205903.jpg?raw=true" width="500"/>
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20210007.jpg?raw=true" width="500"/>
</p>

### `In Mininet`
```bash
# If the flow-entrys set successfully, the pingall will fine.
$ pingall
```
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20210105.jpg?raw=true" width="400"/>
</p>

---
<p align="center">

## 	:point_right:Task 2 - Write a Ryu controller - FLOOD

</p>

#### :pushpin: Use the FLOOD way to transmit packets in Ryu Controller. 
 **```FLOOD : every incoming packet is sent through every outgoing link except the one it arrived on```**

:white_medium_small_square: **mysw_basic.py**
```python
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3

class L2Switch(app_manager.RyuApp):
    OFP_VERSION =[ofproto_v1_3.OFP_VERSION]

    def __init__(self,*args,**kwargs):
        super(L2Switch,self).__init__(*args,**kwargs)
    
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures,CONFIG_DISPATCHER)
    def switch_features_handler(self,ev):
        self.logger.info("******* Add Default Flow *******")
        dp = ev.msg.datapath
        ofp = dp.ofproto
        parser = dp.ofproto_parser
        match = parser.OFPMatch()
        actions =[parser.OFPActionOutput(ofp.OFPP_CONTROLLER,ofp.OFPCML_NO_BUFFER)]
        inst =[parser.OFPInstructionActions(ofp.OFPIT_APPLY_ACTIONS,actions)]
        mod = parser.OFPFlowMod(datapath=dp,priority=0,match=match,instructions=inst)
        dp.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def packet_in_handler(self,ev):
        msg=ev.msg
        dp=msg.datapath
        ofp = dp.ofproto
        parser =dp.ofproto_parser
        self.logger.info("******* Debug *******")
        data = None
        if msg.buffer_id == ofp.OFP_NO_BUFFER:
            data = msg.data

        actions = [parser.OFPActionOutput(ofp.OFPP_FLOOD)]
        out = parser.OFPPacketOut(datapath=dp,buffer_id=msg.buffer_id,in_port=msg.match['in_port'],actions=actions,data=data)
        dp.send_msg(out)
```
```bash
# start the ryu-manager
$ ryu-manager --verbose ryu.app.ofctl_rest network_slice/experiment_1/mysw_basic.py
```
```bash
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Postman`
#### `http://127.0.0.1:8080/stats/flow/1`
#### `GET/json`
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20211058.jpg?raw=true" width="400"/>
</p>

---
<p align="center">

## 	:point_right:Task 3 - Write a Ryu controller - Add FLOOD flow

</p>

#### :pushpin: Add a FLOOD flowentry to transmit packets. 

:white_medium_small_square: **mysw_flow.py**
```python
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3

class L2Switch(app_manager.RyuApp):
    OFP_VERSION =[ofproto_v1_3.OFP_VERSION]

    def __init__(self,*args,**kwargs):
        super(L2Switch,self).__init__(*args,**kwargs)
    
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures,CONFIG_DISPATCHER)
    def switch_features_handler(self,ev):
        self.logger.info("******* Add Default Flow *******")
        dp = ev.msg.datapath
        ofp = dp.ofproto
        parser = dp.ofproto_parser
        match = parser.OFPMatch()
        actions =[parser.OFPActionOutput(ofp.OFPP_CONTROLLER,ofp.OFPCML_NO_BUFFER)]
        inst =[parser.OFPInstructionActions(ofp.OFPIT_APPLY_ACTIONS,actions)]
        mod = parser.OFPFlowMod(datapath=dp,priority=0,match=match,instructions=inst)
        dp.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def packet_in_handler(self,ev):
        msg=ev.msg
        dp=msg.datapath
        ofp = dp.ofproto
        parser =dp.ofproto_parser
        self.logger.info("******* Add FLOOD Flow *******")
        match = parser.OFPMatch()
        actions = [parser.OFPActionOutput(ofp.OFPP_FLOOD)]
        inst = [parser.OFPInstructionActions(ofp.OFPIT_APPLY_ACTIONS,actions)]
        mod = parser.OFPFlowMod(datapath=dp,priority=2048,match=match,instructions=inst)
        dp.send_msg(mod)
```
### `In Mininet`

```bash
# start the ryu-manager
$ ryu-manager --verbose ryu.app.ofctl_rest network_slice/experiment_1/mysw_flow.py
```
```bash
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Postman`
#### `http://127.0.0.1:8080/stats/flow/1`
#### `GET/json`
<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2020-10-15%20211235.jpg?raw=true" width="400"/>
</p>

---
- ## Task 2 vs Task3

### `In Task 2 and Task 3 mininet`

```bash
# Open xterm for h1 and h2 individually
$ xterm h1 h2
```
### `In h1 xterm`
```bash
# iperf server
$ iperf -s
```
### `In h2 xterm`
```bash
# iperf connect to 10.0.0.1, interval 2s
$ iperf -c 10.0.0.1 -i 2
```
 - **Bandwidth Comparison**

<p align="center">
    <img style="border-style:1px;border-style:double;border-color:#8C8C8C" src="https://github.com/xxionhong/network_slice/blob/main/experiment_1/img/2021-01-06%20add.jpg?raw=true" width="600"/>
</p>
