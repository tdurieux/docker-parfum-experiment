FROM registry.fedoraproject.org/fedora:36
RUN dnf -y install cargo && dnf -y clean all