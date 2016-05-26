#!/usr/bin/bash
. admin-openrc

cmd_openstack=$(which openstack)
cmd_grep=$(which grep)

# Create the neutron user
$cmd_openstack user list | $cmd_grep neutron
if [ $? = 0 ]
then
    echo "neutron user already available"
else

	openstack user create --domain default --password pramati123 neutron
fi

# Add the admin role to the neutron user and service project
openstack role add --project service --user neutron admin
# Create neutron service entity
$cmd_openstack service list | $cmd_grep neutron
if [ $? = 0 ]
then
    echo "neutron service already available"
else

	openstack service create --name neutron --description "OpenStack Networking" network
fi
# Create the neutron endpoints
$cmd_openstack endpoint list | $cmd_grep neutron
if [ $? = 0 ]
then
    echo "neutron endpoint already available"
else
	openstack endpoint create --region RegionOne network public http://controller:9696
	openstack endpoint create --region RegionOne network internal http://controller:9696
	openstack endpoint create --region RegionOne network admin http://controller:9696
fi
