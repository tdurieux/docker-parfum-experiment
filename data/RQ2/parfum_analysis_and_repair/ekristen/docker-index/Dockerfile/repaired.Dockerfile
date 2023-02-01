FROM ubuntu:12.04
MAINTAINER Erik Kristensen <erik@erikkristensen.com>

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install python-software-properties build-essential git && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/app

ADD package.json /tmp/package.json
RUN cd /tmp && npm install --production && cp -R node_modules /opt/app && npm cache clean --force;

ADD . /opt/app

ENV NODE_ENV docker

EXPOSE 5100

ENTRYPOINT ["node"]

CMD ["app.js"]

