FROM alpine

# Adding ca-certificates for external communication, and openssh
# for attaching to remote nodes
RUN apk add --no-cache --update curl ca-certificates openssh-client && rm -rf /var/cache/apk/*

ADD ./build/nomad-helper-linux-amd64 /nomad-helper
RUN chmod +x /nomad-helper

ENTRYPOINT ["/nomad-helper"]
