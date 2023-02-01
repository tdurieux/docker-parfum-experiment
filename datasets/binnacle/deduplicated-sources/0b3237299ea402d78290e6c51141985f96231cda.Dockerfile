ARG src_dir="/gortr"

FROM golang:alpine as builder
ARG src_dir

RUN apk --update --no-cache add git && \
    mkdir -p ${src_dir}

WORKDIR ${src_dir}
COPY . .

RUN go build cmd/gortr/gortr.go

FROM alpine:latest as keygen

RUN apk --update --no-cache add openssl
RUN openssl ecparam -genkey -name prime256v1 -noout -outform pem > private.pem

FROM alpine:latest
ARG src_dir

RUN apk --update --no-cache add ca-certificates && \
    adduser -S -D -H -h / rtr
USER rtr

COPY --from=builder ${src_dir}/gortr ${src_dir}/cmd/gortr/cf.pub /
COPY --from=keygen /private.pem /private.pem
ENTRYPOINT ["./gortr"]
