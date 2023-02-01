# Build ah
FROM golang:1.18-alpine3.15 AS ah-builder
ARG VERSION
ARG GIT_COMMIT
WORKDIR /go/src/github.com/artifacthub/ah
COPY go.* ./
COPY cmd/ah cmd/ah
COPY internal internal
WORKDIR /go/src/github.com/artifacthub/ah/cmd/ah
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-X main.version=$VERSION -X main.gitCommit=$GIT_COMMIT" -o /ah .

# Final stage