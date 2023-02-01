FROM buildkite/plugin-tester

RUN apk update && \
 apk upgrade && \
 apk add --no-cache jq
