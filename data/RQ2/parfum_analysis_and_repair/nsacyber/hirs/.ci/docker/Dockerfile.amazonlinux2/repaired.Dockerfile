FROM amazonlinux:2

# Install packages for building HIRS
RUN yum -y update && yum clean all
RUN yum groupinstall -y "Development Tools"
RUN yum install -y wget java-1.8.0-openjdk-devel protobuf-compiler rpm-build cmake make git gcc-c++ doxygen graphviz python3 libssh2-devel openssl protobuf-devel tpm2-tss-devel tpm2-abrmd-devel trousers-devel libcurl-devel && rm -rf /var/cache/yum

# Install EPEL
WORKDIR /tmp
RUN wget -O epel.rpm -nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y ./epel.rpm && rm -rf /var/cache/yum
RUN yum install -y cppcheck log4cplus-devel re2-devel && rm -rf /var/cache/yum

# Set Environment Variables
ENV JAVA_HOME /usr/lib/jvm/java
