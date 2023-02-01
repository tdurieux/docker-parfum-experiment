FROM ubuntu:bionic

RUN mkdir -p /usr/node_app
COPY . /usr/node_app
WORKDIR /usr/node_app
RUN apt-get update ; apt-get install --no-install-recommends -fy git python make g++ npm curl dirmngr apt-transport-https lsb-release ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update ; apt-get -fy --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install --production && npm cache clean --force;

CMD ["npm", "start"]
