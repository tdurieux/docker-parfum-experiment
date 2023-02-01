FROM docker

ENV SLEEP_TIME='5m'
ENV FILTER_SERVICES=''

RUN apk add --update --no-cache bash

COPY shepherd /usr/local/bin/shepherd

ENTRYPOINT ["/usr/local/bin/shepherd"]
