# build stage
FROM golang:1.15.6-alpine3.12 AS builder

WORKDIR /app
RUN apk update && apk add --no-cache git && apk add --no-cache make
RUN apk add --no-cache --update gcc g++
RUN git clone https://github.com/syhlion/gusher.cluster.git  &&\
    cd gusher.cluster && \
    make docker-build

# final stage
FROM scratch
WORKDIR /gusher
COPY --from=builder /app/gusher.cluster/gusher.cluster .

EXPOSE 8888

ENTRYPOINT ["./gusher.cluster"]
