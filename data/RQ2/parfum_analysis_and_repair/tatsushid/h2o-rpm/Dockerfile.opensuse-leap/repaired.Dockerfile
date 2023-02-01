FROM opensuse/leap:42.3
ENV HOME /
RUN zypper -n update
RUN zypper -n install -y rpm-build cmake gcc-c++ tar make openssl-devel ruby ruby-devel bison libuv-devel git rpmdevtools
RUN rpmdev-setuptree
ADD ./rpmbuild/ /rpmbuild/
RUN chown -R root:root /rpmbuild
RUN rpmbuild -ba /rpmbuild/SPECS/h2o.spec
RUN tar -czf /tmp/h2o.tar.gz -C /rpmbuild RPMS SRPMS && rm /tmp/h2o.tar.gz
CMD ["/bin/true"]
