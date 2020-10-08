#!bin/bash

echo "==========replace tacker.conf=========="
mv /etc/tacker/tacker.conf /etc/tacker/tacker.conf.bak
cp script/tacker.conf /etc/tacker/
chmod 744 /etc/tacker/tacker.conf

ip="$(hostname -i)"
echo "$ip"
sleep 5

vim /etc/tacker/tacker.conf

echo "==========upgrade tacker-DB=========="
/usr/bin/tacker-db-manage --config-file /etc/tacker/tacker.conf upgrade head

echo "==========download and install tacker-horizon=========="
cd ~
git clone https://github.com/openstack/tacker-horizon.git -b stable/train
cd tacker-horizon
python setup.py install

echo "==========Enable tacker dashboard=========="
cp tacker_horizon/enabled/_80_nfv.py /usr/share/openstack-dashboard/openstack_dashboard/enabled/

echo "==========restart httpd and openstack=========="
systemctl restart httpd
echo "==========restart openstack-tacker-server=========="
systemctl restart openstack-tacker-server
echo "==========restart openstack-tacker-conductor==========" 
systemctl restart openstack-tacker-conductor
echo "==========enable openstack-tacker-server openstack-tacker-conductor=========="
systemctl enable openstack-tacker-server openstack-tacker-conductor

echo "==========mkdir and chmod=========="
mkdir -p /etc/tacker/vim/fernet_keys
chown tacker:tacker /etc/tacker/* -R

echo "==========end=========="
