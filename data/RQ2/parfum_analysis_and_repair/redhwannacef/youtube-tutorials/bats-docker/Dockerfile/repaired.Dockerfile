FROM bash:4.4

RUN apk add --no-cache git

COPY scripts/initialise.sh /scripts/
RUN /scripts/initialise.sh