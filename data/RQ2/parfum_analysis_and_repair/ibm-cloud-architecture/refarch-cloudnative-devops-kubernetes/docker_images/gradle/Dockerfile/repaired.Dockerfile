FROM gradle:5.0.0-jdk-alpine
RUN apk --no-cache update \
  && apk add --no-cache --update bash jq ca-certificates curl \
  && update-ca-certificates