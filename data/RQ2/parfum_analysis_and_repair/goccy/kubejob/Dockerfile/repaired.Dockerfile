FROM golang:1.17-stretch

ENV GOPATH /go
WORKDIR /go/src/github.com/goccy/kubejob

COPY ./go.* ./

RUN go mod download

COPY . .

RUN go build -o /go/bin/kubejob-agent cmd/kubejob-agent/main.go

FROM gcr.io/distroless/base:debug AS agent

COPY --from=0 /go/bin/kubejob-agent /bin/kubejob-agent