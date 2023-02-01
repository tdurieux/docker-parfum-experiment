FROM python:2.7

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y jq zip && \
  pip install --no-cache-dir awscli && \
  apt-get clean && \
  cd /var/lib/apt/lists && rm -fr *Release* *Sources* *Packages* && \
  truncate -s 0 /var/log/*log && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ["make"]
