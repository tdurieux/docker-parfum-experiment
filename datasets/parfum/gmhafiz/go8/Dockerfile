FROM golang:1.18-buster AS src

WORKDIR /go/src/app/

# Copy dependencies first to take advantage of Docker caching
COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

# Insert version using git tag and latest commit hash
# Build Go Binary
RUN set -ex; \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-X main.Version=$(git describe --abbrev=0 --tags)-$(git rev-list -1 HEAD) -w -s" -o ./server ./cmd/go8/main.go;

# Compress binary using upx https://upx.github.io/ and install CA certificates
RUN apt update && apt install -y upx-ucl ca-certificates
RUN upx ./server

FROM scratch
LABEL com.gmhafiz.maintainers="User <author@example.com>"

WORKDIR /App

COPY --from=src /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=src /go/src/app/server /App/server

# Docker cannot copy hidden .env file. So in Taskfile.yml, we make a copy of it.
COPY --from=src /go/src/app/env.prod /App/.env

# Copies the folder containing swagger assets and our openapi specs.
# Todo: embed the folder using embed tag
COPY --from=src /go/src/app/docs /App/docs

EXPOSE 3080

ENTRYPOINT ["/App/server"]
