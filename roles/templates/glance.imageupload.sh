#!/usr/bin/bash
. /root/admin-openrc
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
openstack image create cirros --file /root/cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public
. /root/admin-openrc
openstack image list
