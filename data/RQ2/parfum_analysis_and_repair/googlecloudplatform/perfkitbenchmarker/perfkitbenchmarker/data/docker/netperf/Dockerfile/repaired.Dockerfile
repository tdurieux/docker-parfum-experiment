FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y gcc make curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz && tar -xzf netperf-2.7.0.tar.gz && rm netperf-2.7.0.tar.gz
RUN cd netperf-netperf-2.7.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

CMD ["/usr/local/bin/netserver", "-D"]
