FROM node:8.1.1

RUN apt-get update -y && apt-get install --no-install-recommends -y sqlite3 build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/osm-cruncher/app && mkdir -p /opt/osm-cruncher/app/results && mkdir -p /opt/osm-cruncher/app/server

WORKDIR /opt/osm-cruncher

COPY package.json /opt/osm-cruncher/package.json
RUN npm install && npm cache clean --force;

COPY app /opt/osm-cruncher/app

WORKDIR /opt/osm-cruncher/app

ENTRYPOINT ["./entrypoint.sh"]
