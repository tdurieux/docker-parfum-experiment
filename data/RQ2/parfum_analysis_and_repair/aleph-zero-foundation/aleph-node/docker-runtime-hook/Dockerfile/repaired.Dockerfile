FROM ubuntu:focal-20211006

RUN apt update && \
 apt install --no-install-recommends curl -y && \
 apt install --no-install-recommends unzip -y && \
 apt install --no-install-recommends git -y && \
 apt install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;

WORKDIR aleph-runtime

COPY bin/cliain/target/release/cliain /aleph-runtime/cliain
RUN chmod +x /aleph-runtime/cliain

COPY docker-runtime-hook/entrypoint.sh /aleph-runtime/entrypoint.sh
RUN chmod +x /aleph-runtime/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]