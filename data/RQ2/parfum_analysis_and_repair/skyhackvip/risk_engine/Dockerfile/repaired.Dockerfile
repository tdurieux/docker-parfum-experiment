# go build 
FROM golang:1.12.16 as build
RUN mkdir -p /app/building
WORKDIR /app/building
ADD . /app/building
ENV GOPROXY https://goproxy.cn
RUN make build

# copy & run