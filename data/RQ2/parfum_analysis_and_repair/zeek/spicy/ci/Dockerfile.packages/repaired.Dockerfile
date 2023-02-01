FROM centos:8

ENV PATH="/opt/rh/gcc-toolset-9/root/bin:${PATH}"

RUN yum install -y epel-release yum-utils && yum-config-manager --set-enabled powertools && rm -rf /var/cache/yum
RUN yum install -y gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ git make flex diffutils glibc-langpack-en && rm -rf /var/cache/yum
SHELL [ "/usr/bin/scl", "enable", "gcc-toolset-9"]

# There's a bug with ld in gcc-toolset-9-gcc <= gcc-toolset-9-gcc-9.2.1-2.2.
# See https://bugzilla.redhat.com/show_bug.cgi?id=1853900.
# Use ld.gold instead.
RUN alternatives --set ld /usr/bin/ld.gold

# Need a more recent CMake than available.
RUN cd /usr/local && curl -f -L https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4-Linux-x86_64.tar.gz | tar xzvf - && ln -s /usr/local/cmake-3.16.4-Linux-x86_64/bin/cmake /usr/local/bin
