FROM node:11.4.0 AS ui
RUN npm install -g npm@7.3.0 && npm cache clean --force;
WORKDIR /go/metahub
COPY ./ui/package* ./ui/
RUN cd ui && npm install && npm cache clean --force;
COPY ./ui ./ui
COPY ./static ./static
COPY ./templates ./templates
WORKDIR /go/metahub/ui/
RUN npm run build

FROM golang:1.12 AS go
WORKDIR /go/metahub
COPY ./go.mod .
COPY ./go.sum .
RUN go mod download
COPY ./cmd ./cmd
COPY ./pkg ./pkg
WORKDIR /go/metahub/cmd/dynamodb
# static build
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -a -ldflags '-extldflags "-static"' .
EXPOSE 8080

# Go binary serves the ui web content
FROM ubuntu:18.04
ENV PORT=80
COPY --from=go /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=ui /go/metahub/static /srv/html/static
COPY --from=ui /go/metahub/templates/gen/index.html /srv/html/
COPY --from=go /go/metahub/cmd/dynamodb/dynamodb /usr/bin/metahub
VOLUME /data/
WORKDIR /data/
CMD ["/usr/bin/metahub"]
