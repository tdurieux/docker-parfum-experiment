FROM golang:1.18

WORKDIR /
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    git version && rm -rf /var/lib/apt/lists/*;

# install the entrypoint helper (finds the main.go)
COPY util util
WORKDIR util/entrypoint
RUN go install

WORKDIR /
COPY entrypoint.sh /
RUN chmod 755 entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
