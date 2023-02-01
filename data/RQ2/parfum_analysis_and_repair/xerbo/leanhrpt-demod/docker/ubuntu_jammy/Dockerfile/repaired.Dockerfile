FROM ubuntu:jammy
COPY build.sh /root
RUN chmod +x /root/build.sh

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get install --no-install-recommends -y git cmake g++ qtbase5-dev libsndfile1-dev libsoapysdr-dev libfftw3-dev file dpkg-dev && rm -rf /var/lib/apt/lists/*;
