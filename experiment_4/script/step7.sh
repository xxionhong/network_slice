#!bin/bash

echo "==========replace config.yaml=========="

cp script/config.yaml /etc/tacker/
chmod 744 /etc/tacker/config.yaml

ip="$(hostname -i)"
echo "$ip"
sleep 5

echo "==========vim admin-openrc.sh=========="

vim script/admin-openrc.sh
source script/admin-openrc.sh

echo "==========vim config.yaml=========="
vim /etc/tacker/config.yaml

echo "==========create vim in openstack=========="
openstack vim register --config-file /etc/tacker/config.yaml --description 'my first vim' --is-default Hello-VIM

echo "==========end=========="
