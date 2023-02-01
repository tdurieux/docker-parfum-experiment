# Build image
FROM golang:1.10.3

WORKDIR /go/src/github.com/HcashOrg/hcd
COPY . .

RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure
RUN CGO_ENABLED=0 GOOS=linux go install . ./cmd/...

# Production image