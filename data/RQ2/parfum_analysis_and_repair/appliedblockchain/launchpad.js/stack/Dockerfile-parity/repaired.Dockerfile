FROM parity/parity:v2.5.5-stable
USER root

RUN mkdir -p /parity

WORKDIR /parity

RUN apt-get update -y && apt-get install --no-install-recommends -y curl bash redis-tools software-properties-common && rm -rf /var/lib/apt/lists/*;

COPY ./parity/chain/spec.json      spec.json
COPY ./parity/chain/reserved_peers reserved_peers

COPY ./entrypoint-parity.sh .

ARG PARITY_ID
RUN echo "Building parity${PARITY_ID}..."

COPY ./parity/${PARITY_ID}/password       password
COPY ./parity/${PARITY_ID}/authority.toml authority.toml
COPY ./parity/${PARITY_ID}/parity         ./data/keys/parity
COPY ./parity/${PARITY_ID}/network.key    ./data/network/key

ENTRYPOINT [ "bash", "./entrypoint-parity.sh" ]
