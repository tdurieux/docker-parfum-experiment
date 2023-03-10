FROM golang:1.13.4 AS build-env
ADD . /src
RUN cd /src && go build -o goapp

FROM alpine
WORKDIR /app
COPY --from=build-env /src/goapp /app/
ENTRYPOINT ./goapp