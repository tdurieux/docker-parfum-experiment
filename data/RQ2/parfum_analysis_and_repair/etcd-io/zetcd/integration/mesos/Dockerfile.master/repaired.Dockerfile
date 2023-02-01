FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install mesos && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["--registry=in_memory"]
ENTRYPOINT ["mesos-master"]
