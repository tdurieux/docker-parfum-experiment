FROM webhippie/ubuntu:20.04-amd64@sha256:40e8b3bdbbcad7d7ada815c5e87e5ae63f4dbc197bead62e38f0131081a98662

VOLUME ["/var/lib/mongodb", "/var/lib/backup"]
EXPOSE 27017 27018 27019

WORKDIR /var/lib/mongodb
CMD ["/usr/bin/container"]

RUN apt-get update && \
  apt-get install --no-install-recommends -y lsb-release gnupg2 && \
  curl -f -sSLo- https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - && \
  echo "deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb.list && \
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
