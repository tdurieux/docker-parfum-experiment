FROM fedora:latest
MAINTAINER Jorge Figueiredo (http://blog.jorgefigueiredo.com)

LABEL Description="Docker Container Discovery"

RUN dnf install -y python-pip && \
	pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir docker python-consul

COPY scripts/* /scripts/
COPY entrypoint.sh /usr/local/bin/
RUN mkdir /var/log/docker-events/

ENTRYPOINT ["entrypoint.sh"]
