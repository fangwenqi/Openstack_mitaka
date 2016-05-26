#!/usr/bin/bash
source admin-openrc

cmd_openstack=$(which openstack)
cmd_grep=$(which grep)

# Create the glance user
$cmd_openstack user list | $cmd_grep glance
if [ $? = 0 ]
then
    echo "glance service already available"
else
    openstack user create --domain default --password pramati123 glance
fi

# Add the admin role to the glance user and service project
openstack role add --project service --user glance admin
# Create the glance service entity
$cmd_openstack service list | $cmd_grep glance
if [ $? = 0 ]
then
    echo "glance service already available"
else
    openstack service create --name glance --description "OpenStack Image" image
fi

# Create the glance endpoints
$cmd_openstack endpoint list | $cmd_grep glance
if [ $? = 0 ]
then
    echo "glance service already available"
else
    openstack endpoint create --region RegionOne image public http://controller:9292
    openstack endpoint create --region RegionOne image internal http://controller:9292
    openstack endpoint create --region RegionOne image admin http://controller:9292
fi
