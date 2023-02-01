FROM ubuntu:xenial

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q \
	python3 virtualenv && rm -rf /var/lib/apt/lists/*;

RUN virtualenv -p /usr/bin/python3 /yacron && \
	/yacron/bin/pip install yacron

COPY yacrontab.yaml /etc/yacron.d/yacrontab.yaml

ENTRYPOINT ["/yacron/bin/yacron"]
