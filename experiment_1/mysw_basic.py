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