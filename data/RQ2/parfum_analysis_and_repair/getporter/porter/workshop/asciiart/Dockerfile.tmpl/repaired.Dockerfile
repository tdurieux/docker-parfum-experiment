FROM golang:1.11-stretch

ARG BUNDLE_DIR

RUN go get github.com/stdupp/goasciiart

COPY gopher-*.png $BUNDLE_DIR/