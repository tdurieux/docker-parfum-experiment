FROM docker.io/paritytech/ci-linux:production as builder
LABEL description="This is the build stage for Parallel. Here we create the binary."

ARG PROFILE=production
ARG BIN=parallel

WORKDIR /parallel

COPY . /parallel

RUN cargo build --workspace --exclude runtime-integration-tests --profile $PROFILE --bin $BIN --features runtime-benchmarks --features try-runtime

# ===== SECOND STAGE ======

FROM docker.io/library/ubuntu:20.04
LABEL description="This is the 2nd stage: a very small image where we copy the Parallel binary."

ARG PROFILE=production
ARG BIN=parallel

ENV BIN_PATH=/usr/local/bin/$BIN

COPY --from=builder /parallel/target/$PROFILE/$BIN /usr/local/bin

RUN apt update -y \
    && apt install --no-install-recommends -y ca-certificates libssl-dev \
    && useradd -m -u 1000 -U -s /bin/sh -d /parallel parallel \
    && mkdir -p /parallel/.local \
    && mkdir /data \
    && chown -R parallel:parallel /data \
    && ln -s /data /parallel/.local/share \
    && chown -R parallel:parallel /parallel/.local/share && rm -rf /var/lib/apt/lists/*;

USER parallel
WORKDIR /parallel
EXPOSE 30333 9933 9944
VOLUME ["/data"]

RUN echo '#!/bin/bash\n$BIN_PATH $@' > .entrypoint.sh
RUN chmod u+x .entrypoint.sh

ENTRYPOINT ["/parallel/.entrypoint.sh"]
