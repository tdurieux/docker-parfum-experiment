# build stage
FROM golang:alpine AS build-env
RUN mkdir /src
ADD client.go /src
RUN cd /src && go build -o client

# final stage