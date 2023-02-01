FROM mongo:3.4
RUN apt-get update && apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://github.com/mongodb/mongo/archive/r4.2.10.tar.gz
RUN tar -xzf r4.2.10.tar.gz && mv mongo-r4.2.10 mongo && rm r4.2.10.tar.gz
RUN wget -q -O - https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
WORKDIR /srv
RUN npm i pgmongo && npm cache clean --force;
RUN rm -r node_modules/mongo-query-to-postgres-jsonb

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y --no-install-recommends install postgresql && rm -rf /var/lib/apt/lists/*;

COPY . node_modules/mongo-query-to-postgres-jsonb
COPY scripts/test.sh .
