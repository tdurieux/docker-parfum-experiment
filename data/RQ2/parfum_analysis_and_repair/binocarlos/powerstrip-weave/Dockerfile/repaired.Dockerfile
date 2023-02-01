FROM node:0.10
MAINTAINER Kai Davenport <kaiyadavenport@gmail.com>
WORKDIR /usr/local/bin
RUN apt-get -y update && apt-get -y --no-install-recommends install curl iptables && rm -rf /var/lib/apt/lists/*;
RUN wget -O /usr/local/bin/weave https://github.com/zettio/weave/releases/download/v0.9.0/weave
RUN chmod a+x /usr/local/bin/weave
ADD . /srv/app
ADD ./docker-1.3.1 /usr/bin/docker
RUN chmod a+x /srv/app/run.sh
RUN cd /srv/app && npm install && npm cache clean --force;
EXPOSE 80
ENTRYPOINT ["/srv/app/run.sh"]