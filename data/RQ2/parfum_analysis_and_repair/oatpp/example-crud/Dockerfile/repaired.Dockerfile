FROM alpine:latest

RUN apk update && apk upgrade

RUN apk add --no-cache g++

RUN apk add --no-cache git
RUN apk add --no-cache make
RUN apk add --no-cache cmake

ADD . /service

WORKDIR /service/utility

RUN ./install-oatpp-modules.sh Release

WORKDIR /service/build

RUN cmake ..
RUN make

EXPOSE 8000 8000

ENTRYPOINT ["./crud-exe"]
