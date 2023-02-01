FROM centos:7

# Packages for building Proxy Verifier and its dependencies.
RUN yum -y update; \
    yum install -y centos-release-scl epel-release && rm -rf /var/cache/yum
RUN yum install -y \
        git wget autoconf automake libtool \
        devtoolset-9 rh-python38-python-devel rh-python38 \
        rh-python38-python-pip openssl11-devel && rm -rf /var/cache/yum

RUN source /opt/rh/rh-python38/enable; \
    pip3 install --no-cache-dir pipenv

# Install the library dependencies in /opt.
WORKDIR /var/tmp
RUN \
    source /opt/rh/rh-python38/enable; \
    source /opt/rh/devtoolset-9/enable; \
    git clone https://github.com/yahoo/proxy-verifier.git; \
    cd proxy-verifier; \
    bash tools/build_library_dependencies.sh /opt
