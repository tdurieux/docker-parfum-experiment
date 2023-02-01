FROM ubuntu:18.04
MAINTAINER Joe Zhu <sha.joe.zhu@gmail.com>
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -qq git build-essential autoconf autoconf-archive libcppunit-dev zlib1g-dev bash-completion -y pkg-config \
    && apt-cache policy zlib* && rm -rf /var/lib/apt/lists/*;
RUN git clone --recursive https://github.com/DEploid-dev/DEploid.git
RUN cd /DEploid/ \
    && ./bootstrap \
    && make install
ENTRYPOINT ["dEploid"]
