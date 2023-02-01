FROM mhart/alpine-node:16

LABEL "com.github.actions.name"="2fa With Slack Action"
LABEL "com.github.actions.description"="A GitHub Action to publish a package with 2FA authentication using Slack"
LABEL "com.github.actions.icon"="hash"
LABEL "com.github.actions.color"="green"

LABEL "repository"="https://github.com/erezrokah/2fa-with-slack-action"
LABEL "homepage"="https://github.com/erezrokah/2fa-with-slack-action"
LABEL "maintainer"="Erez Rokah"
LABEL "version"="1.2.0"

RUN apk add --no-cache --update bash
RUN apk add --no-cache --update python
RUN apk add --no-cache --update alpine-sdk
COPY package.json yarn.lock tsconfig.json /
COPY src/ src/
RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;
ENTRYPOINT ["node", "/index.js"]
