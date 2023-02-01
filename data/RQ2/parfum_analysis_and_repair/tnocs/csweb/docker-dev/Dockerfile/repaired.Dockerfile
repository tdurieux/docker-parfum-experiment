FROM node:4

RUN npm install -g npm && npm cache clean --force;
RUN npm install -g typescript@1.6.2 bower gulp node-gyp && npm cache clean --force;
RUN apt-get update && apt-get install -y --no-install-recommends libkrb5-dev && rm -rf /var/lib/apt/lists/*;

EXPOSE 3002
