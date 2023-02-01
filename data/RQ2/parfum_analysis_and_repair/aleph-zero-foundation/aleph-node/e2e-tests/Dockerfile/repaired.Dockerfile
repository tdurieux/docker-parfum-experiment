FROM ubuntu:focal-20210827

WORKDIR client

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY target/release/aleph-e2e-client /usr/local/bin
RUN chmod +x /usr/local/bin/aleph-e2e-client

COPY docker_entrypoint.sh /client/docker_entrypoint.sh
RUN chmod +x /client/docker_entrypoint.sh

ENTRYPOINT ["./docker_entrypoint.sh"]
