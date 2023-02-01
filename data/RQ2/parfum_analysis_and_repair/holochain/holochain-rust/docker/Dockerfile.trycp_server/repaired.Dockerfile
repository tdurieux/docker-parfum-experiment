ARG DOCKER_BRANCH=develop

FROM alpine:latest as certs
RUN apk add --update --no-cache ca-certificates

FROM jaegertracing/jaeger-agent as agent

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

FROM holochain/holochain-rust:minimal.${DOCKER_BRANCH} as build

COPY --from=agent /go/bin/agent-linux /go/bin/agent-linux
COPY --from=agent /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENV shellfile ./docker/trycp_server.default.nix

RUN echo $NIX_PATH

RUN nix-env -i wget ps more killall gnugrep vim nano which curl

RUN echo $CARGO_HOME

RUN nix-shell $shellfile --run hc-trycp-server-install
RUN nix-shell default.nix --run hc-conductor-install
RUN nix-shell $shellfile --run 'cargo clean'
RUN nix-collect-garbage

# https://stackoverflow.com/questions/22713551/how-to-flatten-a-docker-image#22714556
FROM scratch
COPY --from=build /go/bin/agent-linux /go/bin/agent-linux
COPY --from=build / /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
WORKDIR /holochain
ENV CARGO_HOME /holochain/.cargo
ENV PATH "${CARGO_HOME}/bin:${PATH}"
# this should contain all our freshly built binaries
RUN ls /holochain/.cargo/bin

RUN mkdir /tmp/trycp/conductors -p

CMD trycp_server -c -p 9000 --port-range 5050-5070 & /go/bin/agent-linux --reporter.grpc.host-port ${TRACER_HOST:-final-exam.holo.host}:${TRACER_PORT:-14267}