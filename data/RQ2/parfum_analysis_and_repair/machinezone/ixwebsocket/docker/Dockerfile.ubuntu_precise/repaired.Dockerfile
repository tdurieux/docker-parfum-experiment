# Build time
FROM ubuntu:precise as build

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /tmp/cmake
WORKDIR /tmp/cmake
RUN wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz
RUN tar zxf cmake-3.14.0-Linux-x86_64.tar.gz && rm cmake-3.14.0-Linux-x86_64.tar.gz

RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libz-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

COPY . .

ARG CMAKE_BIN_PATH=/tmp/cmake/cmake-3.14.0-Linux-x86_64/bin
ENV PATH="${CMAKE_BIN_PATH}:${PATH}"

RUN ["make", "ws_no_python"]

ENTRYPOINT ["ws"]
CMD ["--help"]
