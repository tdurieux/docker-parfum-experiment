# MongoDB (gewo/mongodb)
FROM gewo/mongodb-base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ENV MONGODB_VERSION 2.6.11

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  mongodb-org=$MONGODB_VERSION \
  mongodb-org-server=$MONGODB_VERSION \
  mongodb-org-shell=$MONGODB_VERSION \
  mongodb-org-mongos=$MONGODB_VERSION \
  mongodb-org-tools=$MONGODB_VERSION && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

CMD ["start_mongodb"]
