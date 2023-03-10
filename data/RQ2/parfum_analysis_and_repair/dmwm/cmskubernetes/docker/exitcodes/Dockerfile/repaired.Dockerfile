# Start from the latest golang base image
FROM golang:latest
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com
ENV WDIR=/data
WORKDIR $WDIR
RUN go get github.com/sirupsen/logrus
RUN go get -d github.com/shirou/gopsutil/...
RUN go get github.com/vkuznet/CMSExitCodes
#RUN go mod init github.com/vkuznet/CMSExitCodes
#RUN go list -m all
#RUN go get -d -v github.com/vkuznet/CMSExitCodes