FROM python:2.7

ADD . /tahoe-lafs
RUN \
  cd /tahoe-lafs && \
  git pull --depth=100 && \
  pip install --no-cache-dir . && \
  rm -rf ~/.cache/

WORKDIR /root
