FROM fedora:latest
MAINTAINER Jorge Figueiredo (http://blog.jorgefigueiredo.com)

LABEL Description="Docker Container Discovery"

RUN dnf install -y python-pip && \
	pip install --upgrade pip && \
	pip install docker python-consul

COPY scripts/* /scripts/
COPY entrypoint.sh /usr/local/bin/
RUN mkdir /var/log/docker-events/

ENTRYPOINT ["entrypoint.sh"]
