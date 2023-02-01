# iojs (gewo/iojs)
FROM gewo/interactive
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ENV IOJS_VERSION 2.2.1

RUN \
  apt-get update && apt-get install --no-install-recommends -y curl && \
  curl -f https://iojs.org/dist/v${IOJS_VERSION}/iojs-v${IOJS_VERSION}-linux-x64.tar.gz | \
    tar vxz --strip-components=1 -C /usr && \
  apt-get remove --purge -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
