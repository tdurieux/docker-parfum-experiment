FROM rust:stretch as build

ARG STACKS_NODE_VERSION="No Version Info"
ARG GIT_BRANCH='No Branch Info'
ARG GIT_COMMIT='No Commit Info'

WORKDIR /src

COPY . .

RUN mkdir /out

RUN cd testnet/stacks-node && cargo build --features monitoring_prom,slog_json --release
RUN cd testnet/puppet-chain && cargo build --release

RUN cp target/release/stacks-node /out
RUN cp target/release/puppet-chain /out

FROM debian:stretch-slim

RUN apt update && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
COPY --from=build /out/ /bin/

CMD ["stacks-node", "mainnet"]
