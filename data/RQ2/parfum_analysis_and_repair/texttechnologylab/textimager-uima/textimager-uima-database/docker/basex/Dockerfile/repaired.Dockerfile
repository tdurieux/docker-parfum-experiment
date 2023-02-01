FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y basex && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /srv
RUN adduser --home /srv --disabled-password --disabled-login --uid 1984 --gecos "" basex && chown -R basex /srv
USER basex

EXPOSE 1984
CMD ["basexserver"]
