FROM ubuntu:14.04

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  python \
  python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
  requests \
  urllib3 \
  certifi


CMD python -V;bash '/etc/shared/scripts/drive'
