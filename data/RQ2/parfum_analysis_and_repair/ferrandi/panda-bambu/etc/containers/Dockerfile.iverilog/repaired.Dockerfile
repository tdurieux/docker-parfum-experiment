ARG BASE=ubuntu:xenial

#---

FROM $BASE AS base
RUN apt-get update -qq \
   && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
      g++ gcc make \
   && apt-get autoclean && apt-get clean && apt-get -y autoremove \
   && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

#---

FROM base AS build
RUN apt-get update -qq \
   && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
      autoconf bison ca-certificates flex git gperf libfl-dev libreadline-dev \
   && apt-get autoclean && apt-get clean && apt-get -y autoremove \
   && update-ca-certificates \
   && rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch v11-branch https://github.com/steveicarus/iverilog.git /iverilog

ENV PREFIX /opt/iverilog

RUN cd /iverilog \
   && sh autoconf.sh \
   && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/iverilog \
   && make -j4 \
   && make install \
   && make check

#---

FROM base

COPY --from=build /opt/iverilog /opt/iverilog

ENV PATH /opt/iverilog/bin:$PATH
