FROM ubuntu:latest

EXPOSE 9090

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install \ 
  -y -qq --no-install-recommends build-essential cmake libboost-all-dev maven \
  python3 python3-pip python3-setuptools git zip wget zlib1g-dev libssl-dev \
  libcurl4-openssl-dev libtool autoconf automake libnuma-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/jiffy
COPY . /opt/jiffy

WORKDIR /opt/jiffy
RUN mkdir build \
  && cd build \
  && cmake -DBUILD_TESTS=OFF -DBUILD_JAVA_CLIENT=OFF .. \
  && make -j8 install

ENTRYPOINT ["directoryd", "-c", "/opt/jiffy/docker/docker.conf"]
