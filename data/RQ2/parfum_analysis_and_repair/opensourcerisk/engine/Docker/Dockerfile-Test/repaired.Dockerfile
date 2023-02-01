ARG tag=latest
FROM debian:${tag}

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y dos2unix python3 python3-pip libxml2-utils xsltproc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install --no-cache-dir matplotlib pandas nose nose_xunitmp datacompy

CMD bash

