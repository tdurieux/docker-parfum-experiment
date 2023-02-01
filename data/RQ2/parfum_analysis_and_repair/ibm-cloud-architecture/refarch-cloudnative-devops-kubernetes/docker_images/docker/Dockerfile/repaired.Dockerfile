FROM docker:18.09
RUN apk --no-cache update \
  && apk add --no-cache --update bash jq ca-certificates curl openssl \
  && update-ca-certificates