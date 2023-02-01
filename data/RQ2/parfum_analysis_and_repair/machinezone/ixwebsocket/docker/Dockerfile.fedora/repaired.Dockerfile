FROM fedora:30 as build

RUN yum install -y gcc-g++ && rm -rf /var/cache/yum
RUN yum install -y cmake && rm -rf /var/cache/yum
RUN yum install -y make && rm -rf /var/cache/yum
RUN yum install -y openssl-devel && rm -rf /var/cache/yum

RUN yum install -y wget && rm -rf /var/cache/yum
RUN mkdir -p /tmp/cmake
WORKDIR /tmp/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz
RUN tar zxf cmake-3.14.0-Linux-x86_64.tar.gz && rm cmake-3.14.0-Linux-x86_64.tar.gz

ARG CMAKE_BIN_PATH=/tmp/cmake/cmake-3.14.0-Linux-x86_64/bin
ENV PATH="${CMAKE_BIN_PATH}:${PATH}"

RUN yum install -y python && rm -rf /var/cache/yum
RUN yum install -y libtsan && rm -rf /var/cache/yum
RUN yum install -y zlib-devel && rm -rf /var/cache/yum

COPY . .
# RUN ["make", "test"]
RUN ["make"]

# Runtime
FROM fedora:30 as runtime

RUN yum install -y libtsan && rm -rf /var/cache/yum

RUN groupadd app && useradd -g app app
COPY --chown=app:app --from=build /usr/local/bin/ws /usr/local/bin/ws
RUN chmod +x /usr/local/bin/ws
RUN ldd /usr/local/bin/ws

# Now run in usermode
USER app
WORKDIR /home/app

COPY --chown=app:app ws/snake/appsConfig.json .
COPY --chown=app:app ws/cobraMetricsSample.json .

ENTRYPOINT ["ws"]
CMD ["--help"]
