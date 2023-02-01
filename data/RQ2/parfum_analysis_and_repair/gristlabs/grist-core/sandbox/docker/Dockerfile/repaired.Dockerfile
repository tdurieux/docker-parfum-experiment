FROM python:3.9

COPY requirements3.txt /tmp/requirements3.txt

RUN \
  pip3 install --no-cache-dir -r /tmp/requirements3.txt

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y faketime && rm -rf /var/lib/apt/lists/*;

RUN useradd --shell /bin/bash sandbox
USER sandbox
WORKDIR /
