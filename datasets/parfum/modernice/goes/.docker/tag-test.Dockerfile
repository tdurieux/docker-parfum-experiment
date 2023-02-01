FROM golang:1.18
ARG TAGS
ENV TAGS $TAGS
WORKDIR /test
COPY go.mod go.sum /test/
RUN go mod download
COPY . .
CMD go test -v -tags=$TAGS ./...
