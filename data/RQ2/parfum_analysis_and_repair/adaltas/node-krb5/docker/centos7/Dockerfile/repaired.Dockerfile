FROM centos:7

# Install epel (requirement for service nginx)
RUN yum install -y epel-release && rm -rf /var/cache/yum

RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y devtoolset-10-gcc-c++ && rm -rf /var/cache/yum

# Install misc
RUN yum install -y wget git vim sudo make && rm -rf /var/cache/yum

# Install compilation tools
RUN yum install -y python3 make && rm -rf /var/cache/yum

# Install Kerberos libs
RUN yum install -y krb5-devel && rm -rf /var/cache/yum

# Install Node.js via n
ENV NPM_CONFIG_LOGLEVEL info
RUN git clone https://github.com/tj/n /n
RUN cd /n && make install
RUN n 14
RUN n 16

RUN mkdir -p /node-krb5
COPY ./run.sh /run.sh
ENTRYPOINT ["/run.sh"]
