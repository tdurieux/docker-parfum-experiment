FROM phusion/baseimage:0.9.16
MAINTAINER Open Knowledge

# set UTF-8 locale
RUN locale-gen en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale

RUN apt-get -qq update

# Install PostgreSQL and PostGIS
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install \
        postgresql \
        postgresql-contrib \
        postgis postgresql-9.3-postgis-2.1 \
        inotify-tools

# default credentials if none have been provided at runtime
# you should at least set a secure passwords
ENV CKAN_DB ckan
ENV CKAN_USER ckan_user
ENV CKAN_PASS ckan_pass

ENV DATASTORE_DB datastore
ENV DATASTORE_USER datastore_user
ENV DATASTORE_PASS datastore_pass

ENV PGDATA /var/lib/postgresql/9.3/main
ENV PGMAIN /etc/postgresql/9.3/main
RUN mkdir -p $PGDATA && chown -R postgres $PGDATA && chmod -R 700 $PGDATA

# Allow connections from anywhere with valid credentials (md5)
RUN sed -i -e "s|^#listen_addresses =.*$|listen_addresses = '*'|" $PGMAIN/postgresql.conf
RUN echo "host    all    all    0.0.0.0/0    md5" >> $PGMAIN/pg_hba.conf

# Configure runit
ADD ./svc /etc/service/
CMD ["/sbin/my_init"]

VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
EXPOSE 5432

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
