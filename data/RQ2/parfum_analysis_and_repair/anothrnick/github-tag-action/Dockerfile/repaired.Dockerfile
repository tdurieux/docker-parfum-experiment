FROM node:12-alpine3.15
LABEL "repository"="https://github.com/anothrNick/github-tag-action"
LABEL "homepage"="https://github.com/anothrNick/github-tag-action"
LABEL "maintainer"="Nick Sjostrom"

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add --no-cache bash git curl jq && npm install -g semver && npm cache clean --force;

ENTRYPOINT ["/entrypoint.sh"]
