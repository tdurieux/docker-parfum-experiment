FROM debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install build-essential devscripts debhelper fakeroot --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /deb/build
ENTRYPOINT ["debuild"]

