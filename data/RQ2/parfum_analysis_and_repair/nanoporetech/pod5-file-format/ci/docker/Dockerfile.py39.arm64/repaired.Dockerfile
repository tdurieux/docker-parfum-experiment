from git.oxfordnanolabs.local:4567/minknow/images/build-aarch64-gcc9

RUN yum groupinstall "Development Tools" -y
RUN yum install wget openssl-devel libffi-devel bzip2-devel -y && rm -rf /var/cache/yum
RUN wget https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz
RUN tar xvf Python-*
WORKDIR Python-3.9.10/
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make altinstall
RUN rm /usr/bin/python3 && ln -s /usr/local/bin/python3.9 /usr/bin/python3

WORKDIR /