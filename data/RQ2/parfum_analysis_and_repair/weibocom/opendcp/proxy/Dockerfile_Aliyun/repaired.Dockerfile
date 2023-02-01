FROM registry.cn-beijing.aliyuncs.com/opendcp/proxy-env

ADD ./phpredis /phpredis
WORKDIR /phpredis
RUN phpize
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make && make install

WORKDIR /
ADD ./run.sh run.sh

ENTRYPOINT ["./run.sh"]
