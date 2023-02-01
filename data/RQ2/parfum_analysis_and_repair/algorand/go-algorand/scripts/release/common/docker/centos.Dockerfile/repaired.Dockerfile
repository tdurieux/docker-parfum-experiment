FROM centos:7

WORKDIR /root
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y autoconf awscli curl git gnupg2 nfs-utils python36 sqlite3 boost-devel expect jq libtool gcc-c++ libstdc++-devel libstdc++-static rpmdevtools createrepo rpm-sign bzip2 which ShellCheck && rm -rf /var/cache/yum

ENTRYPOINT ["/bin/bash"]

