FROM node:14-slim

RUN apt-get update && \
  apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

ADD . /work/

RUN npm install papaparse influx axios https-proxy-agent && npm cache clean --force;

ENTRYPOINT ["node", "/work/appNew.js"]
