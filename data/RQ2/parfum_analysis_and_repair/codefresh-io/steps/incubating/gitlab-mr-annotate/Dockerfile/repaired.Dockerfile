FROM alpine:3.7

RUN apk -U --no-cache add jq bash curl

COPY ./annotate-mr.sh /annotate-mr.sh

SHELL ["/bin/bash"]

ENTRYPOINT ["/annotate-mr.sh"]