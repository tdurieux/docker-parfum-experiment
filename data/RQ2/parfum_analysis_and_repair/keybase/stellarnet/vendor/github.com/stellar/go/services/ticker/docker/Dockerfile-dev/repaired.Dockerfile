FROM golang:1.16.5-stretch as build

LABEL maintainer="Alex Cordeiro <alexc@stellar.org>"

EXPOSE 5432
EXPOSE 8000

ADD . /src/ticker
WORKDIR /src/ticker
RUN go build -o /opt/stellar/bin/ticker ./services/ticker/

WORKDIR /src/ticker/services/ticker/docker/
RUN ["chmod", "+x", "./dependencies"]
RUN ["./dependencies"]
RUN ["chmod", "+x", "setup"]
RUN ["./setup"]
RUN ["cp", "-r", "conf", "/opt/stellar/conf"]
RUN ["crontab", "-u", "stellar", "/opt/stellar/conf/crontab.txt"]
RUN ["chmod", "+x", "start"]

ENTRYPOINT ["/src/ticker/services/ticker/docker/start"]