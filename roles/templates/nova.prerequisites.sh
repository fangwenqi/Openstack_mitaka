#!/usr/bin/bash
. admin-openrc

cmd_openstack=$(which openstack)
cmd_grep=$(which grep)

# Create the nova user
$cmd_openstack user list | $cmd_grep nova
if [ $? = 0 ]
then
    echo "nova user already available"
else
	openstack user create --domain default --password pramati123 nova
fi

# Add the admin role to the nova user and service project
openstack role add --project service --user nova admin

# Create the nova service  endpoints
$cmd_openstack service list | $cmd_grep nova
if [ $? = 0 ]
then
    echo "nova service already available"
else
	openstack service create --name nova --description "OpenStack Compute" compute
fi

# Create the nova endpoints
$cmd_openstack endpoint list | $cmd_grep nova
if [ $? = 0 ]
then
    echo "nova service already available"
else
	openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%\(tenant_id\)s
	openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1/%\(tenant_id\)s
	openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1/%\(tenant_id\)s
fi
