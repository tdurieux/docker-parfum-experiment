FROM mwaeckerlin/mingw

RUN apt-get update -y -q && apt-get install --no-install-recommends -y \
  golang \
  git \
  libtesseract-dev \
  tesseract-ocr-eng && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/root/go
ENV GO111MODULE=on

ADD . ${GOPATH}/src/github.com/otiai10/gosseract
WORKDIR ${GOPATH}/src/github.com/otiai10/gosseract

ENV TESS_LSTM_DISABLED=1
CMD ["go", "test", "-v", "./..."]
