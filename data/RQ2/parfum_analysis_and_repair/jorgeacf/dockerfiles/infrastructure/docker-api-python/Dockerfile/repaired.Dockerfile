FROM fedora:latest
MAINTAINER Jorge Figueiredo (http://blog.jorgefigueiredo.com)

LABEL Description="Docker Python Client"

RUN dnf install -y python-pip && \
	pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir docker

COPY scripts/* /scripts/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
