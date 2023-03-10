FROM fedora:31

RUN dnf -y update
RUN dnf -y install dnf-plugins-core libdnf-devel redhat-rpm-config meson gcc ninja-build
RUN dnf -y builddep PackageKit

RUN mkdir /build
WORKDIR /build