ARG bitcoin_version=22.0
ARG lnd_version=v0.14.2-beta

ARG balanceofsatoshis_tag=v11.55.0

ARG node_version=16.14.0

###############
FROM debian:${DEBIAN_VERSION}-slim as builder
ARG arch

RUN apt-get update \
    && apt-get install --no-install-recommends -y asciidoctor bison build-essential cmake curl gnupg libaspell-dev libcurl4-gnutls-dev libgcrypt20-dev libjson-c-dev libncursesw5-dev libgnutls28-dev libwebsockets-dev pkg-config python3-dev zlib1g-dev \
    && apt clean all && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY . /build

ARG bitcoin_version
RUN if [ "$arch" = "arm64" ]; then export btc_arch=aarch64; else export btc_arch=x86_64; fi \
 && curl -f -sSLO https://bitcoincore.org/bin/bitcoin-core-${bitcoin_version}/bitcoin-${bitcoin_version}-${btc_arch}-linux-gnu.tar.gz \
 && curl -f -sSLO https://bitcoincore.org/bin/bitcoin-core-${bitcoin_version}/SHA256SUMS \
 && sha256sum --ignore-missing --check SHA256SUMS \
 && tar xzf bitcoin-${bitcoin_version}-${btc_arch}-linux-gnu.tar.gz \
 && mv bitcoin-${bitcoin_version} /bitcoin && rm bitcoin-${bitcoin_version}-${btc_arch}-linux-gnu.tar.gz

ARG lnd_version
RUN curl -f -sSLO https://github.com/lightningnetwork/lnd/releases/download/${lnd_version}/lnd-linux-${arch}-${lnd_version}.tar.gz \
 && curl -f -sSLO https://github.com/lightningnetwork/lnd/releases/download/${lnd_version}/manifest-guggero-${lnd_version}.sig \
 && curl -f -sSLO https://github.com/lightningnetwork/lnd/releases/download/${lnd_version}/manifest-${lnd_version}.txt \
 && curl -f https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/guggero.asc | gpg --batch --import \
 && gpg --batch --verify manifest-guggero-${lnd_version}.sig manifest-${lnd_version}.txt \
 && tar xzf lnd-linux-${arch}-${lnd_version}.tar.gz \
 && mv lnd-linux-${arch}-${lnd_version} /lnd && rm lnd-linux-${arch}-${lnd_version}.tar.gz

RUN cd /build/apps/libwebsockets && mkdir build && cd build && cmake .. -DLWS_WITH_LIBUV=ON && make && make install

RUN cd /build/apps/sc-im/src && make

RUN cd /build/apps/ttyd && mkdir build && cd build && cmake .. && make

RUN cd /build/apps/weechat \
 && mkdir build \
 && cd build \
 && cmake .. -DENABLE_PHP=OFF -DENABLE_PERL=OFF -DENABLE_RUBY=OFF -DENABLE_TCL=OFF -DENABLE_LUA=OFF -DENABLE_GUILE=OFF \
 && make \
 && make install \
 && asciidoctor -b manpage /build/apps/weechat/doc/en/weechat.1.en.adoc

###############
FROM python:3 as python-builder

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential gzip pandoc \
    && apt clean all && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jinja2-cli

RUN curl -f -sSL https://install.python-poetry.org | python -

WORKDIR /build
COPY . /build

RUN cd /build/apps/lndmanage && python -m venv .venv
ENV PATH="/build/apps/lndmanage/.venv/bin:$PATH"
RUN cd /build/apps/lndmanage && pip install --no-cache-dir wheel && pip install --no-cache-dir -r requirements.txt

RUN cd /build/apps/suez && /root/.local/bin/poetry export -f requirements.txt --output requirements.txt --without-hashes

RUN jinja2 /build/apps/apps.7.md /build/apps/apps.json | pandoc -s -t man | gzip > /build/apps/apps.7.gz

RUN mkdir -p /opt \
 && mv \
    /build/apps/charge-lnd/ \
    /build/apps/igniter/ \
    /build/apps/lndmanage/ \
    /build/apps/perfectly-balanced/ \
    /build/apps/rebalance-lnd/ \
    /build/apps/suez/ \
    /opt

###############
FROM golang:1.17-${DEBIAN_VERSION} AS golang-builder
ARG arch

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    && apt clean all && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY . /build

ENV GOARCH=${arch}
ENV GOOS=linux

RUN cd /build/apps/circuitbreaker && mkdir bin && go build -o bin/circuitbreaker

RUN cd /build/apps/lntop && mkdir bin && go build -o bin/lntop cmd/lntop/main.go

RUN cd /build/apps/whatsat && mkdir bin && go build -o bin/whatsat

###############
FROM rust:slim-${DEBIAN_VERSION} AS rust-builder

RUN apt-get update \
    && apt-get install --no-install-recommends -y gzip libssl-dev pandoc pkg-config \
    && apt clean all && rm -rf /var/lib/apt/lists/*;

WORKDIR /build
COPY . /build

ENV CARGO_TARGET_DIR=/build/target

RUN cd /build/apps/csview && cargo build --release

RUN cd /build/apps/dog && cargo build --release
RUN pandoc /build/apps/dog/man/dog.1.md -s -t man | gzip > /build/apps/dog/man/dog.1.gz

RUN cd /build/apps/gping && cargo build --release

RUN cd /build/apps/oha && cargo build --release

###############
FROM python:3.8-slim-${DEBIAN_VERSION}

ARG node_version

ARG balanceofsatoshis_tag

ARG arch

RUN echo "deb http://deb.debian.org/debian ${DEBIAN_VERSION}-backports main" | tee -a /etc/apt/sources.list \
 && apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends \
    bc \
    ca-certificates \
    curl \
    figlet \
    git \
    iputils-ping \
    jq \
    less \
    libaspell15 \
    libc6 \
    libcap2 \
    libpython3.7 \
    libssl1.1 \
    libuv1 \
    links \
    man \
    mc \
    micro \
    nano \
    procps \
    python3-pip \
    screen \
    sysstat \
    telnet \
    tini \
    tmux \
    vim \
    xz-utils \
    zlib1g <VERSION_SPECIFIC_DEPENDENCIES> \
 && apt clean all \
 && rm -rf /var/lib/apt/lists/* \
 && if [ "$arch" = "amd64" ]; then export node_arch=x64; else export node_arch=arm64; fi \
 && curl -sSLO "https://nodejs.org/dist/v$node_version/node-v$node_version-linux-$node_arch.tar.xz" \
 && tar -xf "node-v$node_version-linux-$node_arch.tar.xz" && rm -f "/node-v$node_version-linux-$node_arch.tar.xz" \
 && cd "/node-v$node_version-linux-$node_arch" && cp -r bin lib share /usr/local \
 && cd / && rm -rf "node-v$node_version-linux-$node_arch" \
 && pip3 install --upgrade pip \
 && pip3 install btc2fiat \
 && npm i -g balanceofsatoshis@${balanceofsatoshis_tag} \
 && npm cache clean --force

COPY --from=python-builder /opt/ /opt/

ENV PATH="/opt/lndmanage/.venv/bin:$PATH" LD_LIBRARY_PATH=/usr/local/lib/

RUN chmod +x /opt/igniter/igniter.sh /opt/perfectly-balanced/perfectlybalanced.sh \
 && cd /opt/charge-lnd \
 && <INSTALL_MAYBE_NO_GRPC> \
 && cd /opt/lndmanage \
 && <INSTALL_MAYBE_NO_GRPC> \
 && cd /opt/rebalance-lnd \
 && <INSTALL_MAYBE_NO_GRPC> \
 && cd /opt/suez \
 && <INSTALL_MAYBE_NO_GRPC>

COPY \
    --from=builder \
    /bitcoin/bin/bitcoin-cli \
    /lnd/lncli \
    /build/apps/sc-im/src/sc-im \
    /build/apps/sc-im/src/scopen \
    /build/apps/ttyd/build/ttyd \
    /build/apps/weechat/build/src/gui/curses/normal/weechat \
    /usr/local/bin/
COPY \
    --from=builder \
    /usr/local/lib/libwebsockets.so \
    /usr/local/lib/libwebsockets.so.19 \
    /usr/local/lib/libwebsockets-evlib_uv.so \
    /usr/local/lib/
COPY \
    --from=builder \
    /usr/local/lib/weechat/plugins/ \
    /usr/local/lib/weechat/plugins/

COPY \
    --from=golang-builder \
    /build/apps/circuitbreaker/bin/circuitbreaker \
    /build/apps/lntop/bin/lntop \
    /build/apps/whatsat/bin/whatsat \
    /usr/local/bin/

COPY \
    --from=builder \
    /bitcoin/share/man/man1/bitcoin-cli.1 \
    /build/apps/sc-im/src/sc-im.1 \
    /build/apps/weechat/doc/en/weechat.1 \
    /usr/local/share/man/man1/
COPY --from=python-builder /build/apps/apps.7.gz /usr/share/man/man7/
COPY --from=golang-builder /build/apps/circuitbreaker/circuitbreaker-example.yaml /opt/circuitbreaker/
COPY --from=rust-builder /build/apps/dog/man/dog.1.gz /usr/local/share/man/man1/

COPY \
    --from=rust-builder \
    /build/target/release/csview \
    /build/target/release/dog \
    /build/target/release/gping \
    /build/target/release/oha \
    /usr/local/bin/

COPY motd /etc/motd
COPY start.sh lsh_exec.sh /
RUN chmod +x /start.sh \
 && groupadd -r lnshell --gid=1000 \
 && useradd -r -g lnshell --uid=1000 --create-home --shell /bin/bash lnshell

USER lnshell
WORKDIR /home/lnshell

COPY --chown=lnshell:lnshell install-apps.sh bin/* /home/lnshell/.local/bin/
COPY --chown=lnshell:lnshell apps/apps.json /home/lnshell/.local/share/

ARG version
RUN /bin/bash /home/lnshell/.local/bin/install-apps.sh \
 && chmod +x /home/lnshell/.local/bin/* \
 && echo "export PATH=/home/lnshell/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /home/lnshell/.bashrc \
 && echo "cat /etc/motd" >> /home/lnshell/.bashrc \
 && echo "${version}" > /home/lnshell/.lnshell-version

EXPOSE 7681

ENV USERNAME=umbrel APP_PASSWORD=

CMD [ "/start.sh" ]
