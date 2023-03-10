####################################################################################################
## Builder
####################################################################################################
FROM rust:1.60-alpine3.15 AS builder

ENV SQLX_OFFLINE="true"

RUN apk add --no-cache \
    ca-certificates \
    musl-dev \
    git \
    libmagic \
    file \
    file-dev \
    g++

WORKDIR /mitsuba

COPY . .

RUN cargo build --target x86_64-unknown-linux-musl --release --all-features

####################################################################################################
## Final image
####################################################################################################
FROM alpine:3.15

RUN apk add --no-cache \
    ca-certificates \
    postgresql-client \
    git \
    libmagic \
    file \
    file-dev \
    tini

WORKDIR /mitsuba

ENV SQLX_OFFLINE="true"

COPY --from=builder /mitsuba/target/x86_64-unknown-linux-musl/release/mitsuba /mitsuba/mitsuba
COPY --from=builder /mitsuba/log4rs.yml /mitsuba/log4rs.yml

# Creat persistent data directory
RUN mkdir -p /data

# Add an unprivileged user and set directory permissions
RUN adduser --disabled-password --gecos "" --no-create-home mitsuba \
    && chown -R mitsuba:mitsuba /mitsuba \
    && chown -R mitsuba:mitsuba /data

ENTRYPOINT ["/sbin/tini", "--"]

USER mitsuba

CMD ["./mitsuba", "start"]

VOLUME /data

EXPOSE 8080
EXPOSE 9000

STOPSIGNAL SIGTERM

# Image metadata