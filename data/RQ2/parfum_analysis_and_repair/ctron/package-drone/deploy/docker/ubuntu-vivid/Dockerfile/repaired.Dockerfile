FROM ubuntu:15.04

MAINTAINER Jens Reimann <ctron@dentrassi.de>

# Set this to ensure debconf works

ENV DEBIAN_FRONTEND noninteractive

# Install "add-apt-repository

RUN apt-get update ; apt-get -y --no-install-recommends install software-properties-common dpkg && rm -rf /var/lib/apt/lists/*;

# Enable universe and multiverse

RUN add-apt-repository "deb http://de.archive.ubuntu.com/ubuntu/ vivid universe multiverse" ; add-apt-repository "deb http://de.archive.ubuntu.com/ubuntu/ vivid-updates universe multiverse"

# Install OpenJDK 8

RUN apt-get update ; apt-get -y --no-install-recommends install openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*;

# Install package drone

RUN apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 97A336A9320E6224 ; sh -c "echo deb http://repo.dentrassi.de/apt package-drone main > /etc/apt/sources.list.d/PackageDrone.list"
RUN apt-get update ; apt-get -y --no-install-recommends install package-drone-server && rm -rf /var/lib/apt/lists/*;

# Package drone is running on port 8080

EXPOSE 8080

CMD ["/usr/lib/package-drone-server/instance/server"]