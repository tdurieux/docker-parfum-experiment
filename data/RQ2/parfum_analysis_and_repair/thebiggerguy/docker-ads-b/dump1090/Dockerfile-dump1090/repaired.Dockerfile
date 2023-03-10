# Base Image ##################################################################
FROM multiarch/alpine:armhf-v3.12 as base

RUN apk add --no-cache tini librtlsdr libusb


# Builder Image ###############################################################
FROM base as builder

RUN apk add --no-cache \
        curl ca-certificates \
        coreutils make gcc pkgconf \
        libc-dev librtlsdr-dev libusb-dev


ARG DUMP1090_VERSION
ARG DUMP1090_GIT_HASH
ARG DUMP1090_TAR_HASH


RUN curl -f -L --output 'dump1090-mutability.tar.gz' "https://github.com/mutability/dump1090/archive/${DUMP1090_GIT_HASH}.tar.gz" && \
    sha256sum dump1090-mutability.tar.gz && echo "${DUMP1090_TAR_HASH}  dump1090-mutability.tar.gz" | sha256sum -c
RUN mkdir dump1090 && cd dump1090 && \
    tar -xvf ../dump1090-mutability.tar.gz --strip-components=1 && rm ../dump1090-mutability.tar.gz
WORKDIR dump1090
RUN make DUMP1090_VERSION="${DUMP1090_VERSION}"
RUN make test


# Final Image #################################################################
FROM base

COPY --from=builder /dump1090/dump1090 /usr/local/bin/dump1090

# Raw output
EXPOSE 30002/tcp
# Beast output
EXPOSE 30005/tcp

ENTRYPOINT ["tini", "--", "nice", "-n", "-5", "dump1090", "--net", "--net-bind-address", "0.0.0.0", "--debug", "n", "--mlat", "--net-heartbeat", "5", "--quiet", "--stats-every", "60"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="thebigguy.co.uk@gmail.com" \
      org.label-schema.name="Docker ADS-B - dump1090" \
      org.label-schema.description="Docker container for ADS-B - This is the dump1090 component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"

