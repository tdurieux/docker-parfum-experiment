FROM golang:alpine AS builder
WORKDIR /app
RUN apk add git
RUN go get -u github.com/go-bindata/go-bindata/...
COPY . /app
RUN go generate && go build -o /mcapi

FROM alpine
ENV MCAPI_HTTPAPPHOST=0.0.0.0:8080
EXPOSE 8080
COPY --from=builder /mcapi /mcapi
ENTRYPOINT [ "/mcapi" ]
