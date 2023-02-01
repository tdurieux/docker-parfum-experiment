FROM ubuntu:18.04
LABEL maintainer="1072526820@qq.com"
RUN apt-get update -yqq && \
 apt-get install --no-install-recommends -yqq cmake git uuid-dev gcc g++ autoconf && rm -rf /var/lib/apt/lists/*;
ENV ASIO=/asio
ENV ASIO_INTERNAL=/asio/asio
WORKDIR /
RUN git clone https://github.com/chriskohlhoff/asio.git
WORKDIR $ASIO
RUN git checkout 8087252a0c3c2f0baad96ddbd6554db17a846376
WORKDIR $ASIO_INTERNAL
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make && make install
ENV CINATRA=/cinatra
WORKDIR $CINATRA
RUN git clone https://github.com/qicosmos/cinatra.git
RUN cd  /cinatra/cinatra/example && \
    mkdir build && cd build &&  cmake -DLINUX=True ../ && make
