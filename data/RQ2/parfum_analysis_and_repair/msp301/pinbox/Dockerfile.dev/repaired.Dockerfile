FROM node:lts-buster-slim

RUN apt-get update && apt-get -y --no-install-recommends install yarnpkg && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /pinbox
WORKDIR /pinbox

RUN yarn global add @angular/cli
RUN ng config -g cli.packageManager yarn

USER node