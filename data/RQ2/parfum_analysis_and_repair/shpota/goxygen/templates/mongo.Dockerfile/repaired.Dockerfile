FROM node:16.14.2-alpine3.15 AS JS_BUILD
COPY webapp /webapp
WORKDIR webapp
RUN npm install && npm run build && npm cache clean --force;

FROM golang:1.18.1-alpine3.15 AS GO_BUILD
RUN apk update && apk add --no-cache build-base
COPY server /server
WORKDIR /server
RUN go build -o /go/bin/server

FROM alpine:3.13.5
COPY --from=JS_BUILD /webapp/build* ./webapp/
COPY --from=GO_BUILD /go/bin/server ./
CMD ./server
