# How to build
```bash
docker  build --rm -t="krystism/openstack-keystone" .
```

# Environment Variables
you can pass these arguments using **docker run -e** to override default value.
* MYSQL_ROOT_PASSWORD
* OS_TENANT_NAME : default "admin"
* OS_USER_NAME : default "admin"
* OS_PASSWORD : default "ADMIN_PASS"
* OS_ADMIN_EMAIL : default "admin@example.com"

# Start a keystone instance

Before start a keystone instance, we also need mysql database to store data. I use [mariadb](https://registry.hub.docker.com/_/mariadb/)
instead, you can also use mysql image!
```
docker run -d -e MYSQL_ROOT_PASSWORD=MYSQL_DBPASS -h mysql --name mysql -d mariadb
```
Then we should link the database, create a new keystone instance as follow:
```
docker run -d \
  -e OS_TENANT_NAME=admin\
  -e OS_USERNAME=admin\
  -e OS_PASSWORD=ADMIN_PASS\
  --link mysql:mysql\
  --name keystone\ 
  -h keystone krystism/openstack-keystone
```
It may takes some time to execute initscript, you just need to do is wait about 5s, you can use docker logs to fetch
some info from the instance, once the work is done, you can check if it really works:
```
docker exec -t -i keystone bash
cd /root
source admin-openrc.sh
keystone user-list
```
Enjoy!
