ARG MH_CONFIG=bench.yaml
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
WORKDIR /go/metahub/cmd/boltdb
# static build
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -a -ldflags '-extldflags "-static"' .
EXPOSE 8080

FROM golang:1.12 AS boltq
WORKDIR /go
RUN git clone https://github.com/schmichael/boltq.git \
 && cd boltq \
 && go get -d \
 && go build

# Go binary serves the ui web content
FROM ubuntu:18.04
ENV PORT=80
RUN apt update \
 && apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
ARG MH_CONFIG=${MH_CONFIG}
RUN echo "metahub -config /data/metahub.yaml" > /root/.bash_history
COPY --from=go /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=boltq /go/boltq/boltq /usr/bin/
COPY --from=ui /go/metahub/static /srv/html/static
COPY --from=ui /go/metahub/templates/gen/index.html /srv/html/
COPY --from=go /go/metahub/cmd/boltdb/boltdb /usr/bin/metahub
COPY ./misc/config/${MH_CONFIG} /data/metahub.yaml
VOLUME /data/
WORKDIR /data/
CMD ["/usr/bin/metahub", "-config", "/data/metahub.yaml"]
