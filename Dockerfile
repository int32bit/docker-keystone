FROM krystism/openstack_base
MAINTAINER krystism "krystism@gmail.com"
# install packages
RUN apt-get -y install keystone

# remove the SQLite database file
RUN rm -f /var/lib/keystone/keystone.db

EXPOSE 5000 35357

# copy sql script
COPY keystone.sql /root/keystone.sql

# copy keystone config file
COPY keystone.conf /etc/keystone/keystone.conf


# add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 744 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]
