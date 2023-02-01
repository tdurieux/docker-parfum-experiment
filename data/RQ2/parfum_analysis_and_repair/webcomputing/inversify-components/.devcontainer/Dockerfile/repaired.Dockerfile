FROM node:10

USER root
RUN apt-get update && apt-get -y --no-install-recommends install curl wget zip zsh nano sed sudo git-flow && rm -rf /var/lib/apt/lists/*;

RUN npm i -g typescript@3.9.7 gulp tslint && npm cache clean --force;