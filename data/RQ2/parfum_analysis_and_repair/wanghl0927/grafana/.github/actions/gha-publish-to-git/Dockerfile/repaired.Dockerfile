FROM alpine
RUN apk update
RUN apk add --no-cache rsync git bash

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]