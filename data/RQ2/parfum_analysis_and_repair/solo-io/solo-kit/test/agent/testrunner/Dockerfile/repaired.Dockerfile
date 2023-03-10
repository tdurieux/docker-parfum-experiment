FROM soloio/circleci:latest
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/
COPY root.crt /

# install stan-pub for nats tests
RUN go get -v github.com/nats-io/go-nats-streaming/examples/stan-sub

CMD ["/bin/sh", "-c", "echo 'STARTING SLEEP! Access me.' && /bin/sleep 36000"]