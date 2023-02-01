FROM centos:7

WORKDIR /data
RUN yum install -y mpich openmpi git pkg-config nano gcc bzip2 patch gcc-c++ make mpich-devel openmpi-devel && rm -rf /var/cache/yum
RUN yum install -y sudo && rm -rf /var/cache/yum
