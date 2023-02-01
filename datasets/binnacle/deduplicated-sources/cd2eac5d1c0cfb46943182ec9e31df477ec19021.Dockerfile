# Pull the rhel image from the local repository
FROM registry.centos.org/centos/centos:latest
USER root

MAINTAINER Maintainer_Name

# Update image
RUN yum update -y

# Add Mariahdb software
RUN yum -y install mariadb-server

# Set up Mariahdb database
ADD gss_db.sql /tmp/gss_db.sql
ADD mariadb-prepare-db-dir /usr/libexec/mariadb-prepare-db-dir
RUN /usr/libexec/mariadb-prepare-db-dir
RUN /usr/bin/mysqld_safe --basedir=/usr & \
    sleep 10s && \
    /usr/bin/mysqladmin -u root password 'redhat' && \
    mysql --user=root --password=redhat < /tmp/gss_db.sql && \
    mysqladmin shutdown --password=redhat

# Expose Mysql port 3306
EXPOSE 3306

# Start the service
CMD ["--basedir=/usr"]
ENTRYPOINT ["/usr/bin/mysqld_safe"]

