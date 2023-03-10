FROM golang:1.13-alpine as lachesis
ARG GOPROXY=direct
WORKDIR /usr/src/go-lachesis
COPY . .
RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN go mod download
RUN export GIT_COMMIT=$(git rev-list -1 HEAD) && \
    export GIT_DATE=$(git log -1 --date=short --pretty=format:%ct) && \
    export CGO_ENABLED=1 && \
    export LD_FLAGS="-s -w -X main.gitCommit=$GIT_COMMIT -X main.gitDate=$GIT_DATE" && \
    go build -ldflags "$LD_FLAGS" -o /tmp/lachesis ./cmd/lachesis


FROM nginx:latest
COPY --from=lachesis /tmp/lachesis /usr/bin
RUN apt update && apt install --no-install-recommends -y sudo musl && rm -rf /var/lib/apt/lists/*;
RUN ln -s /lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so
RUN ln -s /lib/libc.musl-x86_64.so /lib/libc.musl-x86_64.so.1
RUN mkdir /snapshots
COPY ./docker/snapshots/index.html /snapshots/
COPY ./docker/snapshots/snapshotting.sh /snapshots/
COPY ./docker/snapshots/90.start-snapshotting.sh /docker-entrypoint.d/

ENV NODE_UID=0
RUN mkdir -p /snapshots/files
VOLUME /snapshots/files
RUN mkdir -p /lachesis/datadir
VOLUME /lachesis/datadir

EXPOSE 80

