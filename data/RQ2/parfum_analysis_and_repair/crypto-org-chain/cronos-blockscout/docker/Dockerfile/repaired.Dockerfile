FROM bitwalker/alpine-elixir-phoenix:1.13

RUN apk --no-cache --update add alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3 file qemu-x86_64

ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0

RUN set -ex && \
    apk --update --no-cache add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -f -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --no-cache --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# Get Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ARG NETWORK_PATH=""
ARG SOCKET_ROOT=""

ENV PATH="$HOME/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV MIX_ENV="prod"
ENV SOCKET_ROOT=${SOCKET_ROOT}
ENV NETWORK_PATH=${NETWORK_PATH}

# Cache elixir deps
ADD mix.exs mix.lock ./
ADD apps/block_scout_web/mix.exs ./apps/block_scout_web/
ADD apps/explorer/mix.exs ./apps/explorer/
ADD apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
ADD apps/indexer/mix.exs ./apps/indexer/
ADD docker/entrypoint.sh ./
ADD docker/prepend_npath.sh ./

RUN mix do deps.get, local.rebar --force, deps.compile

ADD . .

<<<<<<< HEAD
ARG COIN
RUN if [ "$COIN" != "" ]; then \
        sed -i s/"POA"/"${COIN}"/g apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
        sed -i "/msgid \"Ether\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/default.pot; \
        sed -i "/msgid \"Ether\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
        sed -i "/msgid \"ETH\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/default.pot; \
        sed -i "/msgid \"ETH\"/{n;s/msgstr \"\"/msgstr \"${COIN}\"/g}" apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; \
    fi
=======
RUN ./prepend_npath.sh
>>>>>>> master

# Run forderground build and phoenix digest
RUN mix compile

RUN npm install npm@latest && npm cache clean --force;

# Add blockscout npm deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd - && npm cache clean --force;

RUN cd apps/explorer/ && \
    npm install && \
    apk update && apk del --force-broken-world alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3 && npm cache clean --force;


RUN cd apps/block_scout_web/ && \
    mix phx.digest

ENTRYPOINT [ "./entrypoint.sh" ]