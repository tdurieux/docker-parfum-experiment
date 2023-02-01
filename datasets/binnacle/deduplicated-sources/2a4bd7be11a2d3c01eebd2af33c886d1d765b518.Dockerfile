FROM unicon/shibboleth-idp:3.2.0
MAINTAINER lukas@statuscode.ch

# Add Shibboleth config stuff
ADD shibboleth/ /opt/shibboleth-idp/

# Install the LDAP server
RUN yum install -y  https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
RUN yum install -y --enablerepo=centosplus 389-ds
RUN rm -fr /var/lock /usr/lib/systemd/system
ADD ldap/ds-setup.inf /ds-setup.inf
ADD ldap/users.ldif /users.ldif
ADD ldap/nextcloud.ldif /nextcloud.ldif
RUN sed -i 's/checkHostname {/checkHostname {\nreturn();/g' /usr/lib64/dirsrv/perl/DSUtil.pm
RUN sed -i 's/updateSelinuxPolicy($inf);//g' /usr/lib64/dirsrv/perl/*
ADD ldap/DSCreate.pm /usr/lib64/dirsrv/perl/DSCreate.pm
ADD ldap/AdminServer.pm /usr/lib64/dirsrv/perl/AdminServer.pm
RUN setup-ds-admin.pl --silent --file /ds-setup.inf
RUN /usr/sbin/ns-slapd -D /etc/dirsrv/slapd-dir && sleep 3 && ldapmodify -H ldap:/// -f nextcloud.ldif -x -D "cn=Directory Manager" -w password && ldapadd -H ldap:/// -f users.ldif -x -D "cn=Directory Manager" -w password
RUN rm /*.ldif

# Install Apache and PHP 7.0 for Nextcloud
RUN yum -y install centos-release-scl
RUN yum -y install rh-php70 rh-php70-php rh-php70-php-gd rh-php70-php-mbstring rh-php70-php-sqlite httpd git rh-php70-mcrypt rh-php70-php-pdo sudo
RUN scl enable rh-php70 bash
RUN yum -y install centos-release-scl
RUN yum -y install sclo-php70-php-mcrypt.x86_64
RUN chmod -R 777 /opt/
RUN rm -f /etc/httpd/conf.d/nss.conf
ADD apache/httpd.conf /etc/httpd/conf/httpd.conf

# Add the startup file
ADD start.sh /start.sh
RUN chmod a+x /start.sh
