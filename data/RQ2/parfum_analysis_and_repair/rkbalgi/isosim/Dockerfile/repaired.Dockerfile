# stage 1
FROM golang:alpine
MAINTAINER Raghavendra Balgi;rkbalgi@gmail.com
COPY . /home/isosim/app/isosim
WORKDIR /home/isosim/app/isosim/cmd/isosim
RUN go build -v -o app .

# stage 2
FROM alpine
#USER 1001:1001