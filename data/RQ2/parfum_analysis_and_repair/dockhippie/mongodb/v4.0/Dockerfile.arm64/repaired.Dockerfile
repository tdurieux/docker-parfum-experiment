FROM webhippie/ubuntu:16.04-arm64@sha256:5b135899ea24be959374feb53d100c8a22794a9009073f234d16c93db55c8c82

VOLUME ["/var/lib/mongodb", "/var/lib/backup"]
EXPOSE 27017 27018 27019

WORKDIR /var/lib/mongodb
CMD ["/usr/bin/container"]

RUN apt-get update && \
  apt-get install --no-install-recommends -y lsb-release gnupg2 && \
  curl -f -sSLo- https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add - && \
  echo "deb [arch=arm64] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get upgrade -y && \
  mkdir -p /var/lib/mongodb && \
  groupadd -g 1000 mongodb && \
  useradd -u 1000 -d /var/lib/mongodb -g mongodb -s /bin/bash -m mongodb && \
  apt-get install --no-install-recommends -y mongodb-org jq && \
  apt-get purge -y lsb-release gnupg2 && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* /var/lib/mongodb/*

COPY ./overlay /
