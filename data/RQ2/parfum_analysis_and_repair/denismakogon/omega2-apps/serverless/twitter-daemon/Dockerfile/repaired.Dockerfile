# build stage
FROM golang:1.9-alpine AS build-env
ENV D=/go/src/github.com/denismakogon/omega2-apps/serverless/twitter-daemon
ADD . $D
RUN cd $D && go build -o twitter-daemon && cp twitter-daemon /tmp/

# final stage