FROM debian:unstable
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc clang git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglapi-mesa && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglfw3-dev libglew-dev libglm-dev catch2 libassimp-dev libfreetype-dev libboost-dev pkgconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake make ninja-build git blender && rm -rf /var/lib/apt/lists/*;

# Install boost pfr, since debian ships with boost 1.74 and pfr got added  with 1.75
RUN mkdir /temp && cd /temp && git clone https://github.com/boostorg/pfr.git && cp -r pfr/include/boost/* /usr/include/boost && cd / && rm -rf /temp

RUN mkdir /glpp
RUN mkdir /build
RUN mkdir /test
RUN mkdir /output
RUN mkdir -p /install/path

WORKDIR /

ENTRYPOINT ["/bin/bash", "/glpp/scripts/docker_entrypoint.sh"]
CMD ["info"]
