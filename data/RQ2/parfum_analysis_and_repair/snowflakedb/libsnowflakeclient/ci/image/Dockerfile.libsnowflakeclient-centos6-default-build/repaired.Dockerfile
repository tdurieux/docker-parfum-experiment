FROM centos:6.10

RUN mkdir -p /usr/lib64/ccache
ENV PATH="/usr/lib64/ccache:${PATH}"

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y yum-utils && rm -rf /var/cache/yum

# gnu toolsets
RUN yum-config-manager --add-repo http://repo.int.snowflakecomputing.com:81/repos/centos-sclo-rh \
 && yum install -y --nogpgcheck devtoolset-4-{runtime,gcc,gcc-c++,libstdc++-devel,gdb} \
 && ln -s /opt/rh/devtoolset-4/root/usr/bin/gcc /usr/lib64/ccache/gcc52 \
 && ln -s /opt/rh/devtoolset-4/root/usr/bin/g++ /usr/lib64/ccache/g++52 && rm -rf /var/cache/yum
ENV CC='/usr/lib64/ccache/gcc52' CXX='/usr/lib64/ccache/g++52'


RUN yum install -y git && rm -rf /var/cache/yum


# zlib for libsnowflakeclient as build_zlib.sh is not called in its build script
RUN yum install -y zlib zlib-devel && rm -rf /var/cache/yum

# dependencies for libuuid
RUN yum install -y bison gettext gettext-devel && rm -rf /var/cache/yum

# cmake3
RUN yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm &&\
    yum install -y cmake3 && \
    ln -s /usr/bin/cmake3 /usr/lib64/ccache/cmake && rm -rf /var/cache/yum

# python
RUN yum -y install rh-python36 && rm -rf /var/cache/yum
COPY scripts/python3.6.sh /usr/local/bin/python3.6
COPY scripts/python3.6.sh /usr/local/bin/python3
RUN chmod a+x /usr/local/bin/python3.6
RUN chmod a+x /usr/local/bin/python3
COPY scripts/pip.sh /usr/local/bin/pip
RUN chmod a+x /usr/local/bin/pip
RUN pip install --no-cache-dir -U pip

# aws
RUN pip install --no-cache-dir -U awscli
COPY scripts/aws.sh /usr/local/bin/aws
RUN chmod a+x /usr/local/bin/aws

# Dependencies for tests
# cppunit
RUN yum install -y cppunit cppunit-devel && rm -rf /var/cache/yum

# unixodbc
RUN yum install -y unixODBC.x86_64 && rm -rf /var/cache/yum
# re2
RUN yum install -y re2-devel &&\
    echo '/usr/local/lib' >> /etc/ld.so.conf.d/locallib.conf && \
    ldconfig && rm -rf /var/cache/yum

RUN yum install -y which && rm -rf /var/cache/yum

RUN yum install -y jq && rm -rf /var/cache/yum

RUN yum install -y tar.x86_64 && rm -rf /var/cache/yum

RUN yum install -y libtool && rm -rf /var/cache/yum

RUN yum install -y unzip && rm -rf /var/cache/yum

# gosu
RUN curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Java
RUN yum -y install java-1.8.0-openjdk-devel && rm -rf /var/cache/yum

# workspace

RUN mkdir -p /home/user
RUN chmod 777 /home/user
WORKDIR /home/user

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
