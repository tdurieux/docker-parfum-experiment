# ARG BASE_IMAGE

# FROM ${BASE_IMAGE}

# RUN apt-get update
# RUN apt-get install -y --no-install-recommends clang cmake
# RUN apt-get install -y --no-install-recommends libsnappy-dev
# RUN curl https://sh.rustup.rs -sSf -o /root/rustinstall.sh && chmod 0755 /root/rustinstall.sh
# RUN bash -c "/root/rustinstall.sh -y"


# ENV PATH="$HOME/.cargo/bin:$PATH"
# RUN cat /root/.cargo/env
# RUN ls -lah /root/.cargo
FROM rust:1.34.0-slim

RUN apt-get update && apt-get install --no-install-recommends -y clang cmake libsnappy-dev git && rm -rf /var/lib/apt/lists/*;

#RUN adduser --disabled-login --system --shell /bin/false --uid 1000 user

#USER user
#WORKDIR /home/user

RUN git clone https://github.com/romanz/electrs /root/electrs
WORKDIR /root/electrs
RUN git checkout tags/v0.7.1

RUN cargo build --release
RUN cargo install --path .

# Electrum RPC for mainnet, testnet, and regtest
EXPOSE 50001 60001 60401

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
