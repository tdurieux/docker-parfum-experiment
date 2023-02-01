ARG goversion
FROM golang:${goversion}
WORKDIR /src
ENV GO111MODULE=on CGO_ENABLED=0
ARG GOPROXY
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN mkdir /out
ARG ldflags
RUN GOOS=linux   GOARCH=amd64   go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-linux-amd64
RUN GOOS=linux   GOARCH=arm64   go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-linux-arm64
RUN GOOS=linux   GOARCH=ppc64le go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-linux-ppc64le
RUN GOOS=darwin  GOARCH=amd64   go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-darwin-amd64
RUN GOOS=darwin  GOARCH=arm64   go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-darwin-arm64
RUN GOOS=windows GOARCH=amd64   go build -ldflags "$ldflags" -tags clientonly -o /out/relic-client-windows-amd64.exe