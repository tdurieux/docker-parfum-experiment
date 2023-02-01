FROM debian:bullseye-slim

ENV RUNTIME_DEPS "curl ca-certificates libasan6 gdb"

RUN \
    apt-get update && \
    apt-get upgrade --yes --force-yes && \
    apt-get install --yes --force-yes --no-install-recommends ${RUNTIME_DEPS} && \
    rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

# copy files
COPY ./pktvisord /usr/local/sbin/pktvisord
COPY ./crashpad_handler /usr/local/sbin/crashpad_handler
COPY ./pktvisor-reader /usr/local/sbin/pktvisor-reader
COPY ./pktvisor-cli /usr/local/bin/pktvisor-cli
COPY ./docker/entry-cp.sh /entry-cp.sh
COPY ./docker/run.sh /run.sh

# permissions
RUN chmod a+x /usr/local/sbin/pktvisord
RUN chmod a+x /usr/local/sbin/crashpad_handler
RUN chmod a+x /usr/local/sbin/pktvisor-reader
RUN chmod a+x /usr/local/bin/pktvisor-cli
RUN chmod a+x /entry-cp.sh
RUN chmod a+x /run.sh

ENTRYPOINT [ "/entry-cp.sh" ]

