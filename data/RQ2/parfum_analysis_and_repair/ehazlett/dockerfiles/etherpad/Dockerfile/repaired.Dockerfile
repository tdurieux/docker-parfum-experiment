FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gzip git-core curl python libssl-dev pkg-config build-essential supervisor && rm -rf /var/lib/apt/lists/*;
RUN ( cd /tmp && wget https://nodejs.org/dist/v0.10.12/node-v0.10.12.tar.gz -O nodejs.tar.gz && tar zxf nodejs.tar.gz && cd node-* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && rm -rf /tmp/node*) && rm nodejs.tar.gz
RUN (cd /opt && git clone git://github.com/ether/etherpad-lite.git etherpad)
RUN (cd /opt/etherpad && ./bin/installDeps.sh)
ADD settings.json /opt/etherpad/settings.json
ADD supervisor.conf /etc/supervisor/supervisor.conf
VOLUME /opt/etherpad/var

EXPOSE 9001
CMD ["supervisord", "-c", "/etc/supervisor/supervisor.conf", "-n"]
