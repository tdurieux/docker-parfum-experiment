# Build time
FROM debian:buster as build

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /tmp/cmake
WORKDIR /tmp/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz
RUN tar zxf cmake-3.14.0-Linux-x86_64.tar.gz && rm cmake-3.14.0-Linux-x86_64.tar.gz

RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libz-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;

COPY . .

ARG CMAKE_BIN_PATH=/tmp/cmake/cmake-3.14.0-Linux-x86_64/bin
ENV PATH="${CMAKE_BIN_PATH}:${PATH}"

RUN ["make"]

# Runtime
FROM debian:buster as runtime

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
# Runtime
RUN apt-get install --no-install-recommends -y libssl1.1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN ["update-ca-certificates"]

# Debugging
RUN apt-get install --no-install-recommends -y strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y htop && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos '' app
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
