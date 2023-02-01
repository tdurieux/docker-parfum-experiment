# https://hub.docker.com/r/icehe/alpine

FROM alpine

RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN apk add --no-cache php
RUN apk add --no-cache rsync

CMD ["/bin/sh"]
