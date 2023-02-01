# build stage
FROM golang:alpine AS build-env
RUN mkdir /src
ADD server.go /src
RUN cd /src && go build -o server

# final stage