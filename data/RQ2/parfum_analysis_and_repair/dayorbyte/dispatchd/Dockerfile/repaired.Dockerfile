#
# Everything about this is kind of gross, but it does get a server running
#

FROM centos:latest
# OS setup
RUN yum install -y make golang git && rm -rf /var/cache/yum
RUN mkdir -p /app/dispatchd && mkdir -p /data/dispatchd/
RUN yum install -y python-setuptools.noarch gcc-c++ glibc-headers && rm -rf /var/cache/yum
RUN easy_install mako

# protobuf
RUN cd /tmp && curl -f -L -o protobuf-2.6.1.tar.gz https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
RUN cd /tmp && tar -xzf protobuf-2.6.1.tar.gz && rm protobuf-2.6.1.tar.gz
RUN cd /tmp/protobuf-2.6.1/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

# Build dispatchd
ENV BUILD_DIR /app/dispatchd/src/github.com/jeffjenkins/dispatchd/
RUN mkdir -p $BUILD_DIR
COPY . $BUILD_DIR
ENV GOPATH /app/dispatchd
RUN cd $BUILD_DIR && PATH=$PATH:$GOPATH/bin make install

# Runtime configuration
ENV STATIC_PATH $BUILD_DIR/static
RUN cp $BUILD_DIR/config.default.json /etc/dispatchd.json
CMD ["/app/dispatchd/bin/server", "-config-file=/etc/dispatchd.json", "-persist-dir=/data/dispatchd/"]
