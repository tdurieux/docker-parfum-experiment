FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -yq \
      git \
      golang \
      libtesseract-dev \
      libleptonica-dev && rm -rf /var/lib/apt/lists/*;

# Load languages
RUN apt-get install --no-install-recommends -y \
  tesseract-ocr-eng && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/root/go
ENV GO111MODULE=on

# Mount source code of gosseract project
ADD . ${GOPATH}/src/github.com/otiai10/gosseract
WORKDIR ${GOPATH}/src/github.com/otiai10/gosseract

ENV TESS_LSTM_DISABLED=1
CMD ["go", "test", "-v", "./..."]
