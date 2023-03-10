## Multi stage build 1st
FROM golang:1.16 as builder

RUN mkdir /usr/src/klevr && rm -rf /usr/src/klevr
WORKDIR /usr/src/klevr
COPY . /usr/src/klevr/

WORKDIR /usr/src/klevr
RUN go mod tidy
RUN chmod +x build.agent.sh
RUN sh ./build.agent.sh


## Main build
FROM alpine:3.13.2
LABEL version=0.1.4

RUN apk update && apk add --no-cache openssh-client jq bash

COPY --from=builder /usr/src/klevr/Dockerfiles/agent/klevr /
COPY ./Dockerfiles/agent/entrypoint.sh /

ENV K_API_KEY ""
ENV K_PLATFORM ""
ENV K_MANAGER_URL ""
ENV K_ZONE_ID ""

ENTRYPOINT ./entrypoint.sh
EXPOSE 18800
