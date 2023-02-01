FROM golangci/golangci-lint:latest-alpine

RUN \
  apk update && \
  apk add --no-cache vim

ENV GOLINTUI_OPEN_COMMAND=vim

COPY golintui /usr/bin/
CMD ["golintui"]
