FROM ubuntu:jammy
COPY build.sh /root
RUN chmod +x /root/build.sh

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get install --no-install-recommends -y git cmake g++ qtbase5-dev libmuparser-dev file dpkg-dev libshp-dev && rm -rf /var/lib/apt/lists/*;
