FROM node:14-bullseye

USER root

ENV HOME=/usr/src

RUN apt-get update && \
  apt-get install --no-install-recommends build-essential pkg-config python3 libgd-dev -y && \
  npm i -g npm && \
  npm i -g node-gyp && \
  mkdir $HOME/.cache && \
  chown -R node:node $HOME && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

USER node

WORKDIR $HOME

CMD  [ "sh" ]
