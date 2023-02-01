FROM fedora:latest
RUN yum -y install make gcc git-core bash-devel && rm -rf /var/cache/yum

WORKDIR /root
CMD make clean ini.so
