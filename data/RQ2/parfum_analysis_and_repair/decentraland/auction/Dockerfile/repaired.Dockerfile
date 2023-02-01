# latest official node image
FROM node:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends postgresql-client -y && rm -rf /var/lib/apt/lists/*;
RUN npm install -g babel-cli && npm cache clean --force;

# use cached layer for node modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install --unsafe-perm && npm cache clean --force;
RUN mkdir -p /usr/src/app && cp -a /tmp/node_modules /usr/src/app/ && rm -rf /usr/src/app

# add project files
ADD . /usr/src/app
ADD package.json /usr/src/app/package.json
WORKDIR /usr/src/app

CMD npm run start
