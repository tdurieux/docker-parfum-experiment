FROM golang:1.18-alpine

WORKDIR /draft
COPY . ./

RUN apk add --no-cache build-base
RUN apk add --no-cache py3-pip
RUN apk add --no-cache python3-dev libffi-dev openssl-dev cargo
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir azure-cli
RUN apk add --no-cache github-cli

RUN make go-generate

RUN go mod vendor
ENTRYPOINT ["go"]