FROM golang:1.10 as server
WORKDIR /go/src/github.com/Stratoscale/logserver
#
RUN apt update && apt install -y --no-install-recommends libsystemd-dev && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN go build -o /logserver

FROM node:8.9.3-alpine as client
RUN apk add --no-cache git
COPY ./client /client
COPY ./.git /.git
WORKDIR /client
RUN yarn
RUN npm run build

FROM ubuntu:16.04
RUN apt update && apt install --no-install-recommends -y libsystemd-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=server /logserver /usr/bin/logserver
COPY --from=client /client/dist /client/dist
ENTRYPOINT ["logserver"]

