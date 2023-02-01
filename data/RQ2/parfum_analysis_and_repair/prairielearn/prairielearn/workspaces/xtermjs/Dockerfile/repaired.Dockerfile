FROM node:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y emacs-nox vim tmux && rm -rf /var/lib/apt/lists/*;
COPY src /xterm

WORKDIR /xterm
RUN yarn install --frozen-lockfile && yarn cache clean;

ENTRYPOINT node server.js
