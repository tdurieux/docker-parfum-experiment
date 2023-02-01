FROM alpine:3.8
RUN apk upgrade --no-cache && \
    apk --no-cache add ca-certificates git openssh-client tini
RUN install -d -o nobody -g nobody /var/lib/katafygio/data
COPY katafygio /usr/bin/
VOLUME /var/lib/katafygio
USER nobody
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/katafygio"]
