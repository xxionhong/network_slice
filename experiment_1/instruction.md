# Experiment 1
---
## Task 1
```shell
# start the ryu-manager
$ sudo ryu-manager --verbose ryu.app.ofctl_rest
```
```shell
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
#### Using restful way (Postman) to add-flow for the switch. 
### [ofctl_rest page](https://ryu.readthedocs.io/en/latest/app/ofctl_rest.html)
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
```json
#Flow2 (h2->h1)=
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
```json
#Flow3 (ARP)=
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

### `In Terminal`
```shell
# show the flows in s1
$ sudo ovs-ofctl -O openflow13 dump-flows s1

# show the hidden flows in s1
$ sudo ovs-appctl bridge/dump-flows s1
```
### `In Mininet`
```shell
# If the flow-entry set success, the pingall will fine.
$ pingall
```
---
## Task 2
```shell
# start the ryu-manager
$ ryu-manager --verbose ryu.app.ofctl_rest ryu.app.mysw_basic
```
```shell
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Postman`
#### `http://127.0.0.1:8080/stats/flow/1`
#### `GET/json`
---
## Task 3
```shell
# start the ryu-manager
$ ryu-manager --verbose ryu.app.ofctl_rest ryu.app.mysw_flow

```
```shell
# start the mininet
$ sudo mn --mac --switch ovs,protocols=OpenFlow13 --controller remote
```
### `In Postman`
#### `http://127.0.0.1:8080/stats/flow/1`
#### `GET/json`
---