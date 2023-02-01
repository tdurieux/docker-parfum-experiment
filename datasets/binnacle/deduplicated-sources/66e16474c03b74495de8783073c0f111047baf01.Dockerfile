FROM fedora:23

RUN dnf -y update && dnf clean all
RUN dnf -y install \
    findutils binutils gcc tar git \
    gzip zip unzip zlib-devel \
    clang java java-devel python \
    && dnf clean all
ENV JAVA_HOME /usr/lib/jvm/java-openjdk
