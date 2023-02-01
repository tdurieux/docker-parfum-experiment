FROM debian:latest

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  git \
  golang \
  libtesseract-dev \
  tesseract-ocr-eng && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/root/go
ENV GO111MODULE=on

ADD . ${GOPATH}/src/github.com/otiai10/gosseract
WORKDIR ${GOPATH}/src/github.com/otiai10/gosseract

RUN tesseract --version

CMD ["go", "test", "-v", "./..."]
