# Build layer
FROM debian:buster-slim AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes 'gosu=1.10-*' curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL -o /usr/bin/graylog-project https://github.com/Graylog2/graylog-project-cli/releases/download/0.26.0/graylog-project.linux && \
      chmod +x /usr/bin/graylog-project


# Final layer
FROM node:14-buster

COPY --from=build /usr/sbin/gosu /usr/sbin/gosu
COPY --from=build /usr/bin/graylog-project /usr/bin/graylog-project
COPY docker-entrypoint.sh /
COPY build-and-run.sh /
COPY clean.sh /

VOLUME ["/graylog/graylog-project", "/graylog/graylog-project-repos", "/cache"]

WORKDIR /graylog/graylog-project

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["build-and-run"]
