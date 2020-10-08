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

        self.addLink(h1,s1,bw=100)
        self.addLink(h2,s2,bw=100)
        self.addLink(h3,s3,bw=100)
        self.addLink(s1,s2,bw=10,Link=TCLink)
        self.addLink(s2,h3,bw=100)
		self.addLink(s1,s3,bw=100)

topos = {"mytopo":(lambda : MyTopo())}