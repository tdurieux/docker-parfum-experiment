FROM quay.io/centos/centos:7
RUN yum install -y yum-utils && \
    yum install -y openldap openldap-clients openldap-servers openldap-devel && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum
CMD /usr/sbin/slapd -u ldap -d1 '-h ldap:// ldapi:///'
