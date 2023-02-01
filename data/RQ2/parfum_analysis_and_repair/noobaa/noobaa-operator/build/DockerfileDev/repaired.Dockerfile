ARG base_image

# Compile stage
FROM golang AS build-env

# Build Delve
RUN go get github.com/go-delve/delve/cmd/dlv

# Final stage
FROM ${base_image}

ENV WATCH_NAMESPACE=default

EXPOSE 40000

WORKDIR /
COPY --from=build-env /go/bin/dlv /

ENTRYPOINT ["/dlv", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "/usr/local/bin/noobaa-operator"]
CMD  ["operator", "run"]