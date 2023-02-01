FROM centos:5
MAINTAINER Abderrahmane Benbachir abderb@microsoft.com

# Important for unittests
RUN adduser omsagent && groupadd omiusers

RUN mkdir -p /home/scratch
WORKDIR /home/scratch

# Edit the repos files to use vault.centos.org instead
RUN sed -i 's/^mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo && \
    sed -i 's/^#baseurl=http:\/\/mirror\.centos\.org\/centos\//baseurl=http:\/\/vault\.centos\.org\//' /etc/yum.repos.d/*.repo && \
    sed -i 's/\$releasever/5.11/g' /etc/yum.repos.d/*.repo

# Extra repos & dependencies
RUN yum update -y && yum clean all && yum install -y wget epel-release && rm -rf /var/cache/yum

# because Centos5 was deprecated
ADD http://people.centos.org/tru/devtools-2/devtools-2.repo /etc/yum.repos.d/devtools-2.repo
RUN yum update -y && yum install -y devtoolset-2-gcc devtoolset-2-gcc-c++ devtoolset-2-binutils && rm -rf /var/cache/yum
ENV PATH /opt/rh/devtoolset-2/root/usr/bin:$PATH

RUN yum install -y which sudo make tree vim cmake zip git redhat-lsb openssh-clients bind-utils bison gcc-c++ libcxx \
    rpm-devel pam-devel openssl-devel rpm-build mysql-devel curl-devel selinux-policy-devel audit-libs-devel boost148-devel && rm -rf /var/cache/yum

# Autoconf >= 2.67 required by ruby to generate ./configure
ADD http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz /home/scratch/autoconf-2.69.tar.gz
RUN cd /home/scratch && tar -vzxf autoconf-2.69.tar.gz && rm autoconf-2.69.tar.gz
RUN cd /home/scratch/autoconf-2.69 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# Perl >= 5.10 required by openssl-1.1.0, which not installed in centos5
ADD https://github.com/Perl/perl5/archive/v5.24.1.tar.gz /home/scratch/perl.tar.gz
RUN cd /home/scratch && tar -zxvf perl.tar.gz && rm perl.tar.gz
RUN cd /home/scratch/perl5-5.24.1 && ./Configure -des -Dprefix=/usr/local_perl_5_24_1 && make install
ENV PATH /usr/local_perl_5_24_1/bin:$PATH

# OpenSSL
RUN mkdir -p /home/scratch/ostc-openssl
RUN mkdir -p ~/.ssh/ && ssh-keyscan github.com >> ~/.ssh/known_hosts
ADD https://github.com/msgpack/msgpack-c/archive/cpp-2.0.0.zip /home/scratch/msgpack-c-cpp-2.0.0.zip
ADD https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz /home/scratch/rapidjson-1.0.2.tar.gz
ADD https://github.com/openssl/openssl/archive/OpenSSL_1_0_0.tar.gz /home/scratch
ADD https://github.com/openssl/openssl/archive/OpenSSL_1_0_1.tar.gz /home/scratch
ADD https://github.com/openssl/openssl/archive/OpenSSL_1_0_1u.tar.gz /home/scratch
ADD https://github.com/openssl/openssl/archive/OpenSSL_1_1_0.tar.gz /home/scratch
RUN tar -zxf OpenSSL_1_0_0.tar.gz && tar -zxf OpenSSL_1_0_1.tar.gz && tar -zxf OpenSSL_1_0_1u.tar.gz && tar -zxf OpenSSL_1_1_0.tar.gz && rm OpenSSL_1_0_0.tar.gz
RUN mv openssl-OpenSSL_1_0_0 /home/scratch/ostc-openssl/openssl-1.0.0
RUN mv openssl-OpenSSL_1_0_1 /home/scratch/ostc-openssl/openssl-1.0.1
RUN mv openssl-OpenSSL_1_0_1u /home/scratch/ostc-openssl/openssl-1.0.1u
RUN mv openssl-OpenSSL_1_1_0 /home/scratch/ostc-openssl/openssl-1.1.0

# Build OpenSSL
RUN cd /home/scratch/ostc-openssl/openssl-1.0.0 && ./config --prefix=/usr/local_ssl_1.0.0 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw
RUN cd /home/scratch/ostc-openssl/openssl-1.0.1 && ./config --prefix=/usr/local_ssl_1.0.1 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw
RUN cd /home/scratch/ostc-openssl/openssl-1.1.0 && ./config --prefix=/usr/local_ssl_1.1.0 shared -no-ssl2 -no-ec -no-ec2m -no-ecdh && make depend && make && make install_sw

# This OpenSSL is used for building ruby
RUN cd /home/scratch/ostc-openssl/openssl-1.0.1u && ./config --prefix=/usr/local/openssl_1.0.1u shared -no-ssl2 -no-ssl3 && make depend && make && make install_sw

# Ruby
ADD https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.6.tar.gz /home/scratch/ruby-2.6.6.tar.gz
RUN cd /home/scratch && tar -zxf ruby-2.6.6.tar.gz && rm ruby-2.6.6.tar.gz
RUN cd /home/scratch/ruby-2.6.6 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-openssl-dir=/usr/local/openssl_1.0.1u && make && make install

# Fix OpenSSL cert
RUN ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.0.0/ssl/cert.pem
RUN ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.0.1/ssl/cert.pem
RUN ln -sf /etc/pki/tls/cert.pem /usr/local/openssl_1.0.1u/ssl/cert.pem
RUN mkdir /usr/local_ssl_1.1.0/ssl/ && ln -sf /etc/pki/tls/cert.pem /usr/local_ssl_1.1.0/ssl/cert.pem

# Enable sudo
RUN sed -i 's/\srequiretty/!requiretty/g' /etc/sudoers
