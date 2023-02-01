FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install debootstrap && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tmp/bootstrap

CMD ["/usr/sbin/debootstrap", "--variant=minbase", "--arch=amd64", "--include=python3", "focal", "/tmp/bootstrap", "http://mirror.rackspace.com/ubuntu/"]
