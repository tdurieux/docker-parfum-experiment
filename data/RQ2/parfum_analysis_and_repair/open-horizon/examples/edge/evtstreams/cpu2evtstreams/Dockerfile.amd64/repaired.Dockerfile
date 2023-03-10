FROM alpine:latest
RUN apk --no-cache --update add curl ca-certificates wget jq bc

# Install kafka to publish to IBM Event Streams
RUN wget --quiet --output-document=/etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && wget https://github.com/sgerrand/alpine-pkg-kafkacat/releases/download/1.3.1-r0/kafkacat-1.3.1-r0.apk && apk --no-cache add kafkacat-1.3.1-r0.apk && rm kafkacat-1.3.1-r0.apk

# Create hzngroup and hznuser
RUN addgroup -S hzngroup && adduser -S hznuser -G hzngroup

# Run container as hznuser user
USER hznuser

COPY *.sh /
WORKDIR /
CMD /service.sh