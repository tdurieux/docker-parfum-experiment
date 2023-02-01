FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

COPY ${DEBFILE} /tmp/

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends /tmp/${DEBFILE} && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/cypher-shell"]
