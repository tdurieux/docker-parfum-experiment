ARG src_dir="/rtrdump"

FROM golang:alpine as builder
ARG src_dir

RUN apk --update --no-cache add git && \
    mkdir -p ${src_dir}

WORKDIR ${src_dir}
COPY . .

RUN go build cmd/rtrdump/rtrdump.go

FROM alpine:latest
ARG src_dir

RUN apk --update --no-cache add ca-certificates && \
    adduser -S -D -H -h / rtr
USER rtr

COPY --from=builder ${src_dir}/rtrdump /
ENTRYPOINT ["./rtrdump"]
