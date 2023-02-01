FROM python:2.7.12-slim
ENV PYTHONUNBUFFERED 1

# Setup the locales in the Dockerfile
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends locales -y \
    && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

# Install ooniprobe dependencies
RUN set -x \
    && apt-get install --no-install-recommends -y build-essential libdumbnet-dev libpcap-dev tor \
                          libgeoip-dev libffi-dev python-dev python-pip libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN set -x \
    && mkdir -p /ooniprobe

ADD data /ooniprobe/data
ADD ooni /ooniprobe/ooni
ADD MANIFEST.in /ooniprobe
ADD setup.py /ooniprobe
ADD requirements.txt /ooniprobe

WORKDIR /ooniprobe
RUN python setup.py install

EXPOSE 8842
COPY data/ooniprobe.conf.docker /etc/ooniprobe.conf

CMD ["ooniprobe-agent", "run"]
