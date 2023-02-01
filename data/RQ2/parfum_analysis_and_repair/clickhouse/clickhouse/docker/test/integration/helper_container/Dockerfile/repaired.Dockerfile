# docker build -t clickhouse/integration-helper .
# Helper docker container to run iptables without sudo

FROM alpine
RUN apk add --no-cache -U iproute2
