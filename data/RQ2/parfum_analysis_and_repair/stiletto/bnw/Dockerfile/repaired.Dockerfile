FROM docker.io/debian:buster AS base

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -qq update && \
    apt-get -qqy --no-install-recommends install python2.7 python-xapian && rm -rf /var/lib/apt/lists/*;

FROM base AS builder

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends python-virtualenv gcc python2.7-dev && rm -rf /var/lib/apt/lists/*;

RUN python2 -m virtualenv -p python2.7 --system-site-packages /bnw/venv
COPY bnw /bnw/src/bnw
COPY setup.py /bnw/src/setup.py
COPY config.py.docker_env /bnw/config/config.py
RUN cd /bnw/src && /bnw/venv/bin/python2 setup.py install

FROM base

COPY --from=builder /bnw /bnw
ENV PYTHONPATH /bnw/config
ENTRYPOINT ["/bnw/venv/bin/bnw", "-n", "-l-"]
