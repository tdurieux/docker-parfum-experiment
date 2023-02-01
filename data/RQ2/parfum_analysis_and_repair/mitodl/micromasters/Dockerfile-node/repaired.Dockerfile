FROM node:14.18.2

LABEL maintainer "ODL DevOps <mitx-devops@mit.edu>"

RUN apt-get update && apt-get install -y --no-install-recommends libelf1 && rm -rf /var/lib/apt/lists/*;

COPY package.json /src/

COPY scripts /src/scripts

RUN node /src/scripts/install_yarn.js

RUN mkdir -p /home/node/.cache/yarn

RUN chown node:node /home/node/.cache/yarn

USER node
