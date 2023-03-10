# build stage
FROM golang:alpine AS build-stage
WORKDIR /go/src/gitlab.com/verygoodsoftwarenotvirus/blanket

ADD . .
RUN go build -o /blanket gitlab.com/verygoodsoftwarenotvirus/blanket/cmd/blanket

# final stage