FROM centos:7.4.1708

RUN yum -y --disablerepo=* --enablerepo=base --enablerepo=extras --enablerepo=updates install epel-release wget isomd5sum createrepo mkisofs yum-utils mtools dosfstools syslinux && rm -rf /var/cache/yum

RUN yum -y install http://repos.sealingtech.org/edcop/edcop-packages/edcop-repo-1-1.noarch.rpm && rm -rf /var/cache/yum

COPY . /EDCOP

RUN cd /EDCOP/build && ./online-configure.sh && ./build-image.sh && rm -rf ~/build
