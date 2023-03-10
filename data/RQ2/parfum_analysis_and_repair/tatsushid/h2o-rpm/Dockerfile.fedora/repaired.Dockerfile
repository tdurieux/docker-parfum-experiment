FROM fedora:31
ENV HOME /
RUN dnf update -y
RUN dnf install -y rpm-build redhat-rpm-config rpmdevtools cmake gcc-c++ tar make openssl-devel ruby ruby-devel bison libuv-devel git zlib-devel
RUN rpmdev-setuptree
RUN echo '%dist   .fc31' >> /.rpmmacros
ADD ./rpmbuild/ /rpmbuild/
RUN chown -R root:root /rpmbuild
RUN rpmbuild -ba /rpmbuild/SPECS/h2o.spec
RUN tar -czf /tmp/h2o.tar.gz -C /rpmbuild RPMS SRPMS && rm /tmp/h2o.tar.gz
CMD ["/bin/true"]
