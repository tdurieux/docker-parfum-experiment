FROM golang:1.18

RUN apt-get update && apt-get install --no-install-recommends bash make git curl jq nodejs npm -y && rm -rf /var/lib/apt/lists/*;
ENV CONTEXT=abs
COPY . /abs
WORKDIR /abs
RUN go install github.com/jteeuwen/go-bindata/...
RUN go mod vendor

CMD bash
