FROM ubuntu:12.04
MAINTAINER Dan Buch <d.buch@modcloth.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yq && \
    apt-get install --no-install-recommends -yq curl && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    curl -f https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && \
    apt-get update -yq && rm -rf /var/lib/apt/lists/*;

EXPOSE 5432
