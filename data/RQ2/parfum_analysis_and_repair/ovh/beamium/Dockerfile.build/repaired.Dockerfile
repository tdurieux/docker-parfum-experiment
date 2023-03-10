FROM rust:buster AS builder

ARG COMMIT=HEAD
ARG REMOTE=https://github.com/ovh/beamium.git

RUN git clone ${REMOTE} /tmp/beamium

WORKDIR /tmp/beamium
RUN git checkout -f ${COMMIT}
RUN cargo build --release

FROM debian:buster-slim

ENV HOME /opt/beamium

WORKDIR /opt/beamium
RUN groupadd -r beamium && \
  useradd -r -g beamium -d ${HOME} beamium && \
  chown -R beamium:beamium ${HOME}

# curl is useful to be able to curl Beamium's metrics
RUN apt update -y && \
  apt install --no-install-recommends -y ca-certificates curl && \
  rm -rf /var/lib/apt/lists/*

COPY config.yml /etc/beamium/config.yml
COPY --from=builder /tmp/beamium/target/release/beamium /usr/local/bin/beamium

USER beamium:beamium
CMD [ "/usr/local/bin/beamium", "-c", "/etc/beamium/config.yml" ]