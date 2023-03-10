############################
# STEP 1 build executable e2e binary
############################
FROM golang:1.16.9 AS builder

RUN apt-get update && \
	apt-get install --no-install-recommends -y upx-ucl && rm -rf /var/lib/apt/lists/*;

RUN useradd appuser && mkdir /app
WORKDIR /app

# Use go mod with go 1.15
ENV GO111MODULE=on
COPY go.mod go.sum ./
COPY LICENSE ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o /bin/main -a -tags netgo -ldflags '-w -s -extldflags "-static"' ./tests/cmd
RUN upx /bin/main

############################
# STEP 2 build a small image
############################
FROM alpine:3.13

COPY --from=builder /etc/passwd /etc/passwd

COPY --from=builder /bin/main /go/bin/main
COPY --from=builder /app/tests/features /features
COPY --from=builder /app/tests/artifacts /artifacts
COPY --from=builder /app/LICENSE /

# Use an unprivileged user.
USER appuser
ENTRYPOINT ["/go/bin/main"]
