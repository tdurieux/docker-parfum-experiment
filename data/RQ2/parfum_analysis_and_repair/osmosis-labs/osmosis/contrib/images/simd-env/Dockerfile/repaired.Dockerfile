FROM ubuntu:18.04

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y --no-install-recommends install curl jq file && rm -rf /var/lib/apt/lists/*;

ARG UID=1000
ARG GID=1000

USER ${UID}:${GID}
VOLUME [ /simd ]
WORKDIR /simd
EXPOSE 26656 26657
ENTRYPOINT ["/usr/bin/run.sh"]
CMD ["start"]
STOPSIGNAL SIGTERM

COPY run.sh /usr/bin/run.sh
