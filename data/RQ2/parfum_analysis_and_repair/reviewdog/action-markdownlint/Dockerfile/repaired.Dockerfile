FROM node:18-alpine3.14

ENV MARKDOWNLINT_CLI_VERSION=v0.31.1

RUN npm install -g "markdownlint-cli@$MARKDOWNLINT_CLI_VERSION" && npm cache clean --force;

ENV REVIEWDOG_VERSION=v0.14.1

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
    | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN apk --no-cache -U add git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
