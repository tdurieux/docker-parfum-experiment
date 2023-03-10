FROM golang@sha256:ef409ff24dd3d79ec313efe88153d703fee8b80a522d294bb7908216dc7aa168 as builder

RUN apk update && apk add --no-cache gcc libc-dev git

WORKDIR /app/compass

COPY ./go.mod .
COPY ./go.sum .

COPY . .

RUN chmod a+rx build-plugins.sh
RUN sh build-plugins.sh

CMD CGO_ENABLED=0 go test -v -coverpkg ./... ./...

