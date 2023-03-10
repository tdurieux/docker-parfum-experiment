FROM alpine:latest

RUN apk update
RUN apk add --no-cache \
  g++ \
  git \
  musl-dev \
  go \
  tesseract-ocr-dev

ENV GOPATH=/root/go

ADD . ${GOPATH}/src/github.com/otiai10/gosseract
WORKDIR ${GOPATH}/src/github.com/otiai10/gosseract

ENV GOSSERACT_CPPSTDERR_NOT_CAPTURED=1
CMD ["go", "test", "-v", "./..."]
