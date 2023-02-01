FROM ubuntu:16.04
MAINTAINER Sheng Yang <sheng.yang@rancher.com>

RUN apt-get install --no-install-recommends -y \
        libaio1 && rm -rf /var/lib/apt/lists/*;

ENV CONVOY_VERSION v0.5.2
ADD https://github.com/rancher/convoy/releases/download/${CONVOY_VERSION}/convoy.tar.gz /tmp/
RUN tar xvf /tmp/convoy.tar.gz -C /tmp/ \
  && cp /tmp/convoy/convoy* /usr/local/bin/ \
  && rm /tmp/convoy.tar.gz

ADD convoy-start /usr/local/bin/
RUN chmod a+x /usr/local/bin/convoy-start
