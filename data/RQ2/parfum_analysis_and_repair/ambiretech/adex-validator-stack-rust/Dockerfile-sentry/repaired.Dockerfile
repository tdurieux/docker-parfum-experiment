# Builder
FROM rust:1.48.0 as builder

LABEL maintainer="dev@adex.network"

WORKDIR /usr/src/app

COPY . .

# We intall the sentry binary with all features in Release mode
# Inlcude the full backtrace for easier debugging
RUN RUST_BACKTRACE=full cargo install --path sentry --all-features

WORKDIR /usr/local/bin

RUN cp $CARGO_HOME/bin/sentry .

FROM ubuntu:20.04

RUN apt update && apt-get install --no-install-recommends -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*;

# `ethereum` or `dummy`
ENV ADAPTER=

# only applicable if you use the `--adapter ethereum`
ENV KEYSTORE_FILE=
ENV KEYSTORE_PWD=

# Only applicable if you use the `--adapter dummy`
ENV DUMMY_IDENTITY=

# If set it will override the configuration file used
ENV CONFIG=

WORKDIR /usr/local/bin

COPY docs/config/cloudflare_origin.crt /usr/local/share/ca-certificates/

RUN update-ca-certificates

COPY --from=builder /usr/local/bin/sentry .

CMD sentry -a ${ADAPTER:-ethereum} \
            ${KEYSTORE_FILE:+-k $KEYSTORE_FILE} \
            ${DUMMY_IDENTITY:+-i $DUMMY_IDENTITY} \
            ${CONFIG}
