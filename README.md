# How to build
```bash
docker  build --rm -t="krystism/keystone" .
```

# Environment Variables

* MYSQL_ROOT_PASSWORD
* ADMIN_TENANT_NAME 
* ADMIN_TENANT_NAME
* ADMIN_USER_NAME
* ADMIN_PASSWORD
* ADMIN_EMAIL

# start a keystone instance

Before start a keystone instance, we also need mysql database to store data. I use [mariadb](https://registry.hub.docker.com/_/mariadb/)
instead, you can also use mysql image, of cource!
```
docker run -d -e MYSQL_ROOT_PASSWORD=MYSQL_DBPASS -h mysql --name mysql -d mariadb:latest
```
Then we should link the database, create a new keystone instance as follow:
```
docker run -d  --link mysql:mysql --name keystone -h keystone krystism/keystone:latest
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
