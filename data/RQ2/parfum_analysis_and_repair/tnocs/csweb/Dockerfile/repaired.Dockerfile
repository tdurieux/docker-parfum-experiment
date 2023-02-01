FROM node:4

RUN useradd -ms /bin/bash node
ADD . /home/node/app
RUN chown -R node:node /home/node

RUN npm install -g npm && npm cache clean --force;
RUN npm install -g typescript@1.6.2 bower gulp node-gyp && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;

USER node
ENV HOME /home/node

EXPOSE 3002
WORKDIR /home/node/app
RUN npm install && npm cache clean --force;
RUN gulp init
WORKDIR /home/node/app/example
CMD node server.js
