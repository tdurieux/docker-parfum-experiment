FROM ubuntu:xenial AS install

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl coreutils && \
    ln -s /usr/bin/sha1sum /usr/bin/shasum && rm -rf /var/lib/apt/lists/*;

ADD scripts/install install-slipway

RUN ./install-slipway

FROM gcr.io/distroless/cc

COPY --from=install /usr/local/bin/slipway /usr/bin/slipway

ENTRYPOINT [ "slipway" ]