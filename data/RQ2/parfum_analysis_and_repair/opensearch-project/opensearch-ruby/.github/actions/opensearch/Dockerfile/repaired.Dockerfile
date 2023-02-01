FROM docker:stable

RUN apk add --no-cache --update bash

COPY run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
