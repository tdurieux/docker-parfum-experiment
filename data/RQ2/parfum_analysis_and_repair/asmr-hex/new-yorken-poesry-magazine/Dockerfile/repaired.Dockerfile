# multi-stage build

# build the server
FROM golang:1.9-alpine as server

WORKDIR /go/src/github.com/connorwalsh/new-yorken-poesry-magazine/server
COPY ./server .
# no need to go get since we are vendoring all our deps
RUN go install -v

# copy server binary into final resting place