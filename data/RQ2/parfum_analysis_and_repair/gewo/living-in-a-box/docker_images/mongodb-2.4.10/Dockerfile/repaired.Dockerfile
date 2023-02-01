# MongoDB (gewo/mongodb)
FROM gewo/mongodb-base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ENV VERSION 2.4.10

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y mongodb-10gen=${VERSION} && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

CMD ["start_mongodb"]
