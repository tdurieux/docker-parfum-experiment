ARG registry
ARG apt_source
FROM $registry/labtainer.centos.xtra
LABEL description="This is base Docker image for Labtainer mariadb servers"
ENV APT_SOURCE $apt_source
RUN /usr/bin/yum-source.sh

#
#RUN $ sudo yum install wget
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
RUN chmod +x mariadb_repo_setup
RUN ./mariadb_repo_setup
RUN yum install -y MariaDB-server && rm -rf /var/cache/yum
RUN yum -y install openldap-clients nss-pam-ldapd nscd openssl authconfig chkconfig pam pam-devel && rm -rf /var/cache/yum
RUN systemctl enable mariadb.service
#
# To use PAM for authentication, Mariadb must be able to read the shadow file
#
RUN groupadd shadow
RUN usermod -a -G shadow mysql
RUN chown root:shadow /etc/shadow
RUN chmod g+r /etc/shadow
