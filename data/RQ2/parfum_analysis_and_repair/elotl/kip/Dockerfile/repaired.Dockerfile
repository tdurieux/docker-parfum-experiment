FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
        apt-get upgrade -y && \
        apt-get install --no-install-recommends -y ca-certificates iptables && rm -rf /var/lib/apt/lists/*;

copy third_party /third_party

COPY kipctl /kipctl
RUN chmod 755 /kipctl
COPY kip /kip
RUN chmod 755 /kip

ENTRYPOINT ["/kip"]
