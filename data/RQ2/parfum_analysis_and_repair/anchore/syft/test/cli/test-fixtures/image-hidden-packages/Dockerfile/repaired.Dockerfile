FROM centos:7.9.2009
# all-layers scope should pickup on vsftpd
RUN yum install -y vsftpd && rm -rf /var/cache/yum
RUN yum remove -y vsftpd