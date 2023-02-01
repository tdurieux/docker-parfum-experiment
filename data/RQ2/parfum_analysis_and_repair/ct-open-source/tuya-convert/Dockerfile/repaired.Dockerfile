FROM phusion/baseimage:master

RUN apt-get update && apt-get install --no-install-recommends -y sudo iproute2 iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

COPY docker/bin /usr/bin/

COPY . /usr/bin/tuya-convert

RUN cd /usr/bin/tuya-convert && ./install_prereq.sh

RUN mkdir -p /etc/service/tuya && cd /etc/service/tuya && ln -s /usr/bin/config.sh run
