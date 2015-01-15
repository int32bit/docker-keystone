#!/bin/bash

# create database for keystone
export MYSQL_ROOT_PASSWORD=${MYSQL_ENV_MYSQL_ROOT_PASSWORD}
export MYSQL_HOST=mysql
SQL_SCRIPT=/root/keystone.sql
mysql -uroot -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOST <$SQL_SCRIPT


# modify the config file
CONFIG_FILE=/etc/keystone/keystone.conf
sed -i "s#^connection.*=.*#connection = mysql://keystone:KEYSTONE_DBPASS@${MYSQL_HOST}/keystone#" $CONFIG_FILE
export ADMIN_TOKEN=${ADMIN_TOKEN:-ADMIN_TOKEN}
sed -i "s#^admin_token.*=.*#admin_token = $ADMIN_TOKEN#" $CONFIG_FILE
su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-all &

# it may take some time to start keystone service, waiting for it.
sleep 5

export OS_SERVICE_TOKEN=${ADMIN_TOKEN}
export OS_SERVICE_ENDPOINT=http://${HOSTNAME}:35357/v2.0

ADMIN_TENANT_NAME=${ADMIN_TENANT_NAME:-admin}
ADMIN_USER_NAME=${ADMIN_USER_NAME:-admin}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-ADMIN_PASS}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@example.com}
keystone tenant-create --name $ADMIN_TENANT_NAME --description "Admin Tenant"
keystone user-create --name $ADMIN_USER_NAME --pass $ADMIN_PASSWORD --email $ADMIN_EMAIL
keystone role-create --name admin
keystone user-role-add --tenant $ADMIN_TENANT_NAME --user $ADMIN_USER_NAME --role admin
keystone role-create --name _member_
keystone user-role-add --tenant $ADMIN_TENANT_NAME --user $ADMIN_USER_NAME --role _member_
keystone tenant-create --name service --description "Service Tenant"
keystone service-create --name keystone --type identity --description "OpenStack Identity"
KEYSTONE_HOST=${KEYSTONE_HOST:-$HOSTNAME}
keystone endpoint-create \
	--service-id $(keystone service-list | awk '/ identity / {print $2}') \
	--publicurl http://${KEYSTONE_HOST}:5000/v2.0 \
	--internalurl http://${KEYSTONE_HOST}:5000/v2.0 \
	--adminurl http://${KEYSTONE_HOST}:35357/v2.0 \
	--region regionOne
# create a admin-openrc.sh file
ADMIN_OPENRC=/root/admin-openrc.sh
cat >$ADMIN_OPENRC <<EOF
export OS_TENANT_NAME=$ADMIN_TENANT_NAME
export OS_USERNAME=$ADMIN_USER_NAME
export OS_PASSWORD=$ADMIN_PASSWORD
export OS_AUTH_URL=$OS_SERVICE_ENDPOINT
EOF
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
# FIXME I need restart
pkill keystone-all
keystone-all
