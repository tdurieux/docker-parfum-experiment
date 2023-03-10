# brunoric/docker-hhvm:deb
FROM ubuntu:trusty
MAINTAINER brunoric <brunoric@gmail.com>

ARG HHVM_VERSION=hhvm

# Installing packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y --no-install-recommends install software-properties-common wget supervisor && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
RUN apt-get update
RUN apt-get -y --no-install-recommends install ${HHVM_VERSION} && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && apt-get autoremove -y

# Scripts
ADD supervisor-config/ /etc/supervisor/conf.d/
ADD scripts/ /scripts/
RUN chmod 755 /scripts/*.sh

# Exposing HHVM-FastCGI port
EXPOSE 9000

# Default command
CMD ["/scripts/start.sh"]
