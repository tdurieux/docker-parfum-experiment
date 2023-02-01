FROM ubuntu:16.04
ENV NPM_CONFIG_LOGLEVEL warn

# tippecanoe, parallel
RUN apt-get update && apt-get install --no-install-recommends -y curl git build-essential libsqlite3-dev zlib1g-dev && \
  git clone https://github.com/mapbox/tippecanoe.git && \
  cd tippecanoe && make && make install && \
  apt-get update && apt-get install --no-install-recommends -y parallel && rm -rf /var/lib/apt/lists/*;

# Node
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Bring in skynet-data
WORKDIR /workdir
ADD package.json /workdir/package.json
RUN npm install && npm cache clean --force;

# downgrade to non-privileged user
RUN groupadd -g 1000 -r data && useradd --no-log-init -r -u 1000 -g data data
USER data

ADD . /workdir

ENTRYPOINT ["make"]
CMD ["all"]
