FROM centos:8
ENV HOME /
RUN { \
        echo '[Devel]'; \
        echo 'name=CentOS-$releasever - Devel'; \
        echo 'mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=Devel&infra=$infra'; \
        echo '#baseurl=http://mirror.centos.org/$contentdir/$releasever/Devel/$basearch/os/'; \
        echo 'gpgcheck=1'; \
        echo 'enabled=1'; \
        echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial'; \
    } > /etc/yum.repos.d/CentOS-Devel.repo
RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y rpm-build redhat-rpm-config rpmdevtools cmake gcc-c++ tar make openssl-devel ruby ruby-devel bison automake libtool libuv-devel git && rm -rf /var/cache/yum
RUN rpmdev-setuptree
RUN echo '%dist   .el8' >> /.rpmmacros
ADD ./rpmbuild/ /rpmbuild/
RUN chown -R root:root /rpmbuild
RUN rpmbuild -ba /rpmbuild/SPECS/h2o.spec
RUN tar -czf /tmp/h2o.tar.gz -C /rpmbuild RPMS SRPMS && rm /tmp/h2o.tar.gz
CMD ["/bin/true"]
