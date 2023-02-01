FROM golang:latest AS builder
RUN apt-get update
# Install nodejs.
RUN apt-get install -y --no-install-recommends curl && \
    curl -f -sL https://deb.nodesource.com/setup_13.x | bash && \
    apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/app
# Caching node modules.
COPY ./browser/package.json ./browser/package.json
RUN cd ./browser && npm install && npm cache clean --force;
COPY ./browser ./browser
RUN cd ./browser && npm run build

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
# Caching go modules and build the binary.
COPY go.mod .
RUN go mod download
COPY . .
RUN go install

FROM scratch
COPY --from=builder /go/src/app/browser ./browser
COPY --from=builder /go/bin/app .
ENTRYPOINT ["./app"]