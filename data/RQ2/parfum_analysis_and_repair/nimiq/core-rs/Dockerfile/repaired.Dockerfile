FROM ubuntu:20.04
RUN apt-get update \
 && apt-get install --no-install-recommends -y libssl1.1 \
 && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

COPY ./scripts/docker_*.sh /root/
COPY ./target/debug/nimiq-client /bin/
WORKDIR /root

ENV NIMIQ_HOST=localhost.localdomain \
    NIMIQ_NETWORK=dev-albatross \
    NIMIQ_LOG_LEVEL=debug \
    NIMIQ_VALIDATOR=none \
    VALIDATOR_BLOCK_DELAY=250 \
    RPC_ENABLED=false

EXPOSE 8443/tcp 8648/tcp

VOLUME [ "/root/database" ]

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/root/docker_run.sh" ]
