FROM centos:latest
VOLUME ["/ovirt"]
RUN rpm -Uvh http://mirror.chpc.utah.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install install livecd-tools appliance-tools-minimizer && rm -rf /var/cache/yum
RUN yum -y install fedora-packager python-devel rpm-build createrepo && rm -rf /var/cache/yum
RUN yum -y install selinux-policy-doc checkpolicy selinux-policy-devel && rm -rf /var/cache/yum
RUN yum -y install autoconf automake python-mock python-lockfile && rm -rf /var/cache/yum

ADD ./buildovirt.sh /buildovirt.sh
ENTRYPOINT ["./buildovirt.sh"]
CMD ["master"]
