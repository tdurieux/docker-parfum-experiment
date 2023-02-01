FROM golang:latest as builder
WORKDIR /src/lyra
RUN pwd
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -

# download and maximise caching go modules
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go mod download
COPY . .
RUN make docker-build
# Copy binaries over to a new container
FROM alpine
WORKDIR /src/lyra/
ENV PATH /src/lyra/build/bin:$PATH
COPY --from=builder /src/lyra/build/bin/lyra /src/lyra/build/bin/lyra
RUN apk add --no-cache ca-certificates
RUN mkdir /src/lyra/local
COPY --from=builder /src/lyra/build/goplugins /src/lyra/build/goplugins
COPY --from=builder /src/lyra/workflows /src/lyra/workflows
COPY --from=builder /src/lyra/examples /src/lyra/examples
COPY --from=builder /src/lyra/docs /src/lyra/docs
COPY --from=builder /src/lyra/build/types /src/lyra/build/types
COPY --from=builder /src/lyra/data.yaml /src/lyra
CMD lyra apply foobernetes
