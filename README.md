## Short Description

Keystone is an OpenStack project that provides Identity, Token, Catalog and Policy services for use specifically by projects in the OpenStack family. This project aim to deploy Keystone service using Docker and can be upgraded easily.

## Quick Start

For the impatient, I simplify some boring step using `Makefile`.

### 1. Build the image

```bash
git clone https://github.com/int32bit/docker-keystone.git
cd docker-keystone
make
```

### 2. Start The Keystone Service

```bash
make run
```

You can use `make log` to track log and `make exec` to enter instance context using shell.

### 3. Remove Keytone container

```bash
make clean
```

## Quick Start Using Docker Compose

If you want to use docker-compose you can simply run:

```docker-compose up -d```

## How to use this image

Openstack Keystone Service uses an SQL database (default sqlite) to store data. The official documentation recommends use MariaDB or MySQL.

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=MYSQL_DBPASS -h mysql --name some-mysql -d mariadb
```

Start your Keystone Service :

```bash
docker run --name some-keystone --hostname controller -e ADMIN_PASSWORD=nomoresecret --link some-mysql:mysql -p 5000:5000 -p 35357:35357  -d openstack-keystone
```

The following environment variables should be change according to your practice.

* `-e MYSQL_ROOT_PASSWORD=...`: Defaults to the value of the `MYSQL\_ROOT\_PASSWORD` environment variable from the linked mysql container.
* `-e MYSQL_HOST=...`: If you use an external database, specify the address of the database. Defautls to "mysql".

It may takes seconds to do some initial work, you can use `docker logs` to detect the progress. Once the Openstck Keystone Service is started, you can verify operation of the Identity service as follows:

```
docker exec -t -i keystone bash
cd /root
source openrc
openstack token issue
openstack user list
openstack project list
```

## Environment Variables

Before you create a Keystone Service, you can adjust the additional configuration of the Openstack Keystone Service by passing one or more environment variables on the docker run command line. 

* `-e ADMIN_TOKEN`: defaults to "ADMIN\_TOKEN"
* `-e ADMIN_TENANT_NAME=...`: Defaults to "admin".
* `-e ADMIN_USER_NAME=...`: Defaults to "admin".
* `-e ADMIN_PASSWORD=...`: Defaults to "ADMIN\_PASS".
* `-e ADMIN_EMAIL=...`: Defaults to "admin@example.com".
