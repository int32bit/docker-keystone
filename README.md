## Short Description

Keystone is an OpenStack project that provides Identity, Token, Catalog and Policy services for use specifically by projects in the OpenStack family. 

## How to build this image

```bash
docker  build --rm -t="openstack-keystone" .
```

## How to use this image

Openstack Keystone Service uses an SQL database to store information. We use MariaDB or MySQL depending on the distribution. We recommend using Docker to deploy a Mysql/MariaDB server quickly as follows:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=MYSQL_DBPASS -h mysql --name some-mysql -d mariadb
```

Then start your Openstack Keystone Service like this:

```bash
docker run --name some-keystone --link some-mysql:mysql -p 5000:5000 -p 35357:35357  -d openstack-keystone
```

The following environment variables are needed for configuring your Openstack Keystone Service:

* `-e MYSQL\_ROOT\_PASSWORD=...`: Defaults to the value of the `MYSQL\_ROOT\_PASSWORD` environment variable from the linked mysql container.
* `-e MYSQL\_HOST=...`: If you use an external database, specify the address of the database. Defautls to "mysql".

It may takes seconds to do some initial work, you can use `docker logs` to detect the progress from the instance. Once the Openstck Keystone Service is started, you can check its work as follows:

```
docker exec -t -i keystone bash
cd /root
source admin-openrc.sh
keystone user-list
```

## Environment Variables

When you start this image, you can adjust the additional configuration of the Openstack Keystone Service by passing one or more environment variables on the docker run command line. 

* `ADMIN\_TOKEN`: defaults to "ADMIN\_TOKEN"
* `-e OS\_TENANT\_NAME=...`: Defaults to "admin".
* `-e OS\_USER\_NAME=...`: Defaults to "admin".
* `-e OS\_PASSWORD=...`: Defaults to "ADMIN\_PASS".
* `-e OS\_ADMIN\_EMAIL=...`: Defaults to "admin@example.com".
