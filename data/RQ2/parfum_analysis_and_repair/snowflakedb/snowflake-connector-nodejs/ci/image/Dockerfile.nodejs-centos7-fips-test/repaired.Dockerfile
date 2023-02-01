FROM centos:7

# update OS and install basic utils
RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install centos-release-scl && rm -rf /var/cache/yum
RUN yum -y install git && rm -rf /var/cache/yum
RUN yum -y install which && rm -rf /var/cache/yum

# python
RUN yum -y install python36 && rm -rf /var/cache/yum
RUN python3 -V
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -U snowflake-connector-python

# aws
RUN pip3 install --no-cache-dir -U awscli
RUN aws --version

# zstd
RUN yum -y install zstd && rm -rf /var/cache/yum

# jq
RUN yum -y install jq && rm -rf /var/cache/yum

# gosu
RUN curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu

# Install build tools
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install centos-release-scl && rm -rf /var/cache/yum
RUN yum -y install devtoolset-8-gcc* && rm -rf /var/cache/yum
SHELL [ "/usr/bin/scl", "enable", "devtoolset-8"]

# node-fips environment variables
ENV NODE_HOME $HOME/node
ENV NODEJS_VERSION 8.16.2
ENV FIPSDIR $HOME/install-openssl-fips
ENV OPENSSL_VERSION 2.0.16

# Install OpenSSL
RUN cd $HOME
RUN curl -f https://www.openssl.org/source/openssl-fips-$OPENSSL_VERSION.tar.gz -o $HOME/openssl-fips-$OPENSSL_VERSION.tar.gz
RUN tar -xvf $HOME/openssl-fips-$OPENSSL_VERSION.tar.gz && rm $HOME/openssl-fips-$OPENSSL_VERSION.tar.gz
RUN mv openssl-fips-$OPENSSL_VERSION $HOME/openssl-fips
RUN cd $HOME/openssl-fips

# You must run ONLY these commands when building the FIPS version of OpenSSL
RUN cd $HOME/openssl-fips && ./config && make && make install

# Download and build NodeJS
RUN git clone --branch v$NODEJS_VERSION https://github.com/nodejs/node.git $NODE_HOME
RUN gcc --version
RUN g++ --version
RUN cd $NODE_HOME && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --openssl-fips=$FIPSDIR && make -j2 & > /dev/null && make install
# Should be $NODEJS_VERSION
RUN node --version
# Should be $OPENSSL_VERSION
RUN node -p "process.versions.openssl"

# workspace
RUN mkdir -p /home/user
RUN chmod 777 /home/user
WORKDIR /home/user

# entry point
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
