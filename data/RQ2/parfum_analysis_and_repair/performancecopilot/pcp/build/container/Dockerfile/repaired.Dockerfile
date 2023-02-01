# rpm build container
FROM registry.fedoraproject.org/fedora:34
COPY . /usr/src/pcp

WORKDIR /usr/src/pcp
RUN dnf install -y git rpm-build 'dnf-command(builddep)' && \
    # pmdabind2
    dnf install -y perl-XML-LibXML perl-File-Slurp && \
    dnf builddep -y build/rpm/redhat.spec && \
    mkdir -p /root/rpmbuild/SOURCES && \
    ./Makepkgs --source && \
    mv build/tar/pcp-*.src.tar.gz /root/rpmbuild/SOURCES && \
    rpmbuild -bb build/rpm/redhat.spec

WORKDIR /root/rpmbuild/RPMS/x86_64
RUN mkdir /build && \
    release=$(ls pcp-zeroconf-* | sed -E 's/pcp-zeroconf-(.+)\.(.+)\.rpm/\1/') && \
    cp /root/rpmbuild/RPMS/noarch/pcp-doc-$release.noarch.rpm /build && \
    cp \
      pcp-$release.x86_64.rpm \
      pcp-zeroconf-$release.x86_64.rpm \
      pcp-conf-$release.x86_64.rpm \
      pcp-libs-$release.x86_64.rpm \
      pcp-selinux-$release.x86_64.rpm \
      pcp-system-tools-$release.x86_64.rpm \
      pcp-pmda-dm-$release.x86_64.rpm \
      pcp-pmda-nfsclient-$release.x86_64.rpm \
      pcp-pmda-openmetrics-$release.x86_64.rpm \
      python3-pcp-$release.x86_64.rpm \
      /build

# actual container