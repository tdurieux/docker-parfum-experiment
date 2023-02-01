FROM alpine

# install the fortune command
RUN apk add --no-cache fortune
COPY docker_entrypoint.sh /docker_entrypoint.sh
COPY book-quotes.* /
VOLUME /var/local/output
ENTRYPOINT ["/docker_entrypoint.sh"]

