FROM rust:bullseye

WORKDIR /src

COPY . .

RUN cd / && wget https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0-x86_64-linux-gnu.tar.gz
RUN cd / && tar -xvzf bitcoin-0.20.0-x86_64-linux-gnu.tar.gz && rm bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

RUN ln -s /bitcoin-0.20.0/bin/bitcoind /bin/
RUN ln -s /bitcoin-0.20.0/bin/bitcoin-cli /bin/

RUN apt-get update && apt-get install --no-install-recommends -y jq screen net-tools ncat sqlite3 xxd openssl curl && rm -rf /var/lib/apt/lists/*;

RUN cargo build --workspace

ENV PATH="/src/target/debug:/src/net-test/bin:${PATH}"

WORKDIR /src/net-test/tests
RUN ./run.sh
