#!/usr/bin/bash
# Create the service entity and API endpoints
export OS_TOKEN=7d72ca47e1262b92f5c7
export OS_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

cmd_openstack=$(which openstack)
cmd_grep=$(which grep)

# Create keystone service 
$cmd_openstack service list | $cmd_grep keystone
if [ $? = 0 ]
then
    echo "keystone service already available"
else
openstack service create --name keystone --description "OpenStack Identity" identity
fi

# create keystone endpoints
$cmd_openstack user list | $cmd_grep keystone
if [ $? = 0 ]
then
    echo "keystone service already available"
else
	openstack endpoint create --region RegionOne identity public http://controller:5000/v3
	openstack endpoint create --region RegionOne identity internal http://controller:5000/v3
	openstack endpoint create --region RegionOne identity admin http://controller:35357/v3
fi
# Create project users and roles
openstack domain create --description "Default Domain" default
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default  --password pramati123 admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password pramati123 demo
openstack role create user
openstack role add --project demo --user demo user

# Verify operation
#unset OS_TOKEN OS_URL
#openstack --os-auth-url http://controller:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin token issue --password pramati123
#openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo token issue --password pramati123
