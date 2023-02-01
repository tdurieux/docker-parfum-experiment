FROM centos:6.10
MAINTAINER Abderrahmane Benbachir abderb@microsoft.com
ARG vcores=8

# Important for unittests
RUN adduser omsagent && groupadd omiusers
RUN usermod -aG wheel omsagent

RUN mkdir -p /home/scratch
WORKDIR /home/scratch

RUN curl -f https://mdsdbuild.blob.core.windows.net/repofiles/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo \
    && yum -y install centos-release-scl \
    && curl -f https://mdsdbuild.blob.core.windows.net/repofiles/centos6-scl-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl.repo \
    && curl -f https://mdsdbuild.blob.core.windows.net/repofiles/centos6-scl-rh-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && rm -rf /var/cache/yum

RUN yum install -y centos-release-scl yum-utils && yum-config-manager --enable rhel-server-rhscl-8-rpms && rm -rf /var/cache/yum

# Extra repos & dependencies
RUN yum update -y && yum install -y epel-release && rm -rf /var/cache/yum

RUN yum install -y which wget sudo make tree vim cmake zip redhat-lsb \
    openssh-clients bind-utils bison gcc-c++ libcxx libstdc++-static rpm-devel \
    pam-devel openssl-devel rpm-build mysql-devel curl-devel selinux-policy-devel \
    audit-libs-devel boost148-devel lsof net-tools patch curl tar bzip2 unzip \
    && yum clean all && rm -rf /var/cache/yum

# Devtoolset-2 (gcc 4.8)
RUN wget --no-check-certificate https://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
RUN yum update -y && yum install -y devtoolset-2-gcc devtoolset-2-gcc-c++ devtoolset-2-binutils && rm -rf /var/cache/yum
# Devtoolset-7 (gcc 7.3)
RUN yum install -y devtoolset-7-toolchain && rm -rf /var/cache/yum
# Devtoolset-8 (gcc 8.3)
RUN yum install -y devtoolset-8-toolchain && rm -rf /var/cache/yum
# Enable Devtoolset-7 by default
ENV PATH /opt/rh/devtoolset-7/root/usr/bin:$PATH

# git
ADD https://github.com/git/git/archive/v2.17.1.tar.gz /home/scratch/v2.17.1.tar.gz
RUN tar -xzf v2.17.1.tar.gz && rm v2.17.1.tar.gz
RUN cd git-2.17.1/ && make configure && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make all && make install

# OpenSSL
RUN mkdir -p /home/scratch/ostc-openssl
RUN mkdir -p ~/.ssh/ && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN git clone --branch OpenSSL_1_0_0 https://github.com/openssl/openssl.git /home/scratch/ostc-openssl/openssl-1.0.0
RUN git clone --branch OpenSSL_1_0_1 https://github.com/openssl/openssl.git /home/scratch/ostc-openssl/openssl-1.0.1
RUN git clone --branch OpenSSL_1_1_0 https://github.com/openssl/openssl.git /home/scratch/ostc-openssl/openssl-1.1.0
# Build OpenSSL
RUN cd /home/scratch/ostc-openssl/openssl-1.0.0 && ./config --prefix=/usr/local_ssl_1.0.0 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw
RUN cd /home/scratch/ostc-openssl/openssl-1.0.1 && ./config --prefix=/usr/local_ssl_1.0.1 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw
RUN cd /home/scratch/ostc-openssl/openssl-1.1.0 && ./config --prefix=/usr/local_ssl_1.1.0 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw
# Fix OpenSSL cert
RUN ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.0.0/ssl/cert.pem
RUN ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.0.1/ssl/cert.pem
RUN mkdir /usr/local_ssl_1.1.0/ssl/ && ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.1.0/ssl/cert.pem

# Autoconf >= 2.67 required by ruby
ADD http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz /home/scratch/autoconf-2.69.tar.gz
RUN tar -vzxf autoconf-2.69.tar.gz && rm autoconf-2.69.tar.gz
RUN cd autoconf-2.69 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Ruby 2.6
#ADD https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.0.tar.gz /home/scratch/ruby-2.6.0.tar.gz
#RUN cd /home/scratch && tar -zxf ruby-2.6.0.tar.gz
#RUN cd /home/scratch/ruby-2.6.0 && ./configure --prefix=/usr && make && make install

# Ruby 2.4
ADD https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.4.tar.gz /home/scratch/ruby-2.4.4.tar.gz
RUN cd /home/scratch && tar -zxf ruby-2.4.4.tar.gz && rm ruby-2.4.4.tar.gz
RUN cd /home/scratch/ruby-2.4.4 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install


