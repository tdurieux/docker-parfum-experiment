FROM golang:latest as go-builder
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com
ENV WDIR=/data
ENV USER=promxy
EXPOSE 8082
WORKDIR $WDIR
ENV VER=v0.0.75
RUN curl -ksLO https://github.com/jacksontj/promxy/releases/download/${VER}/promxy-${VER}-linux-amd64 && mv promxy-${VER}-linux-amd64 promxy && chmod +x /data/promxy

FROM alpine:3.16
RUN mkdir -p /data
COPY --from=go-builder /data/promxy /data/
