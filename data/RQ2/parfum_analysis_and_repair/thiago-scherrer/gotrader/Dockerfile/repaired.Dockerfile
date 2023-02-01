# ------------------------------------------------------------------------------
# build
# ------------------------------------------------------------------------------
FROM golang:1.14.2 AS builder

LABEL NAME golang
LABEL VERSION 2.0

ENV APP /src/gotrader

WORKDIR ${APP}/src/gotrader

RUN mkdir -p ${APP}/src/gotrader

COPY . ${APP}/src/gotrader

RUN cd ${APP}/src/gotrader \
    && go mod download 

RUN mv configs/*.yml /opt/ \
    && cd ${APP}/src/gotrader \
    && cd cmd \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /bin/gotrader \
    && useradd gotrader

# ------------------------------------------------------------------------------
# daemon image
# ------------------------------------------------------------------------------