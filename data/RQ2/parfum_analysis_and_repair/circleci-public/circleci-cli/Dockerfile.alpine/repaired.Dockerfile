FROM alpine:3.8

ENV CIRCLECI_CLI_SKIP_UPDATE_CHECK true

COPY ./dist/circleci-cli_linux_amd64/circleci /usr/local/bin

RUN apk add --no-cache --upgrade git openssh ca-certificates

ENTRYPOINT ["circleci"]