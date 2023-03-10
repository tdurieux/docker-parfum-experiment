FROM rhel:7.2-released

# MySQL image for OpenShift.
#
# Volumes:
#  * /var/lib/mysql/data - Datastore for MySQL
# Environment:
#  * $MYSQL_USER - Database user name
#  * $MYSQL_PASSWORD - User's password
#  * $MYSQL_DATABASE - Name of the database to create
#  * $MYSQL_ROOT_PASSWORD (Optional) - Password for the 'root' MySQL account

ENV MYSQL_VERSION=5.5 \
    HOME=/var/lib/mysql

LABEL summary="MySQL is a multi-user, multi-threaded SQL database server" \
      io.k8s.description="MySQL is a multi-user, multi-threaded SQL database server" \
      io.k8s.display-name="MySQL 5.5" \
      io.openshift.expose-services="3306:mysql" \
      io.openshift.tags="database,mysql,mysql55"

# Labels consumed by Red Hat build service
LABEL BZComponent="openshift-mysql-docker" \
      Name="openshift3/mysql-55-rhel7" \
      Version="5.5" \
      Release="25" \
      Architecture="x86_64"

EXPOSE 3306

# This image must forever use UID 27 for mysql user so our volumes are
# safe in the future. This should *never* change, the last test is there
# to make sure of that.
RUN yum install -y yum-utils && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    INSTALL_PKGS="rsync tar gettext hostname bind-utils mysql55" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/mysql/data && chown -R mysql.0 /var/lib/mysql && \
    test "$(id mysql)" = "uid=27(mysql) gid=27(mysql) groups=27(mysql)" && rm -rf /var/cache/yum

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/mysql \
    MYSQL_PREFIX=/opt/rh/mysql55/root/usr \
    ENABLED_COLLECTIONS=mysql55

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

ADD root /

# this is needed due to issues with squash
# when this directory gets rm'd by the container-setup
# script.
RUN rm -rf /etc/my.cnf.d/*
RUN /usr/libexec/container-setup

VOLUME ["/var/lib/mysql/data"]

USER 27

ENTRYPOINT ["container-entrypoint"]
CMD ["run-mysqld"]
