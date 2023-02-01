FROM golang

RUN apt-get update && \
    apt install --no-install-recommends -y protobuf-compiler && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1 && rm -rf /var/lib/apt/lists/*;

COPY gen_all.sh /bin/gen_all.sh

WORKDIR /

ENTRYPOINT ["/bin/gen_all.sh"]