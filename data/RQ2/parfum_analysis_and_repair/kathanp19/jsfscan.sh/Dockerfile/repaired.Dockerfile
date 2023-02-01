#FROM ubuntu:latest
FROM golang:latest
MAINTAINER bolli95 "maxlukasboll@gmail.com"

# first set the right working dir
WORKDIR /jsfscan

# copy all files to the container
COPY . .

# install all depedencies