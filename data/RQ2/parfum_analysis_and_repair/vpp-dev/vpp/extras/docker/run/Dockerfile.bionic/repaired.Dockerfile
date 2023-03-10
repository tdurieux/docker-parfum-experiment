FROM ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
ARG REPO=release
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packagecloud.io/install/repositories/fdio/${REPO}/script.deb.sh | bash
RUN apt-get update
RUN apt-get -y --no-install-recommends install vpp vpp-plugins && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y purge curl
RUN apt-get -y clean
CMD ["/usr/bin/vpp","-c","/etc/vpp/startup.conf"]

