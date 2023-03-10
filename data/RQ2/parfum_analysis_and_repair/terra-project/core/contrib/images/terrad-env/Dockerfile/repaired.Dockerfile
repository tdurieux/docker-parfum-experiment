FROM ubuntu:18.04

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y --no-install-recommends install curl jq file && rm -rf /var/lib/apt/lists/*;

ARG UID=1000
ARG GID=1000

USER ${UID}:${GID}
VOLUME /terrad
WORKDIR /terrad
EXPOSE 26656 26657
ENTRYPOINT ["/usr/bin/wrapper.sh"]
CMD ["start", "--log_format", "plain"]
STOPSIGNAL SIGTERM

COPY wrapper.sh /usr/bin/wrapper.sh
