FROM registry.erda.cloud/erda/terminus-golang:1.14 AS builder

COPY . /go/src/github.com/erda-project/erda-actions
WORKDIR /go/src/github.com/erda-project/erda-actions

# go build
RUN GOOS=linux GOARCH=amd64 go build -o /opt/action/run github.com/erda-project/erda-actions/actions/mobile-template/1.0/internal/cmd

FROM registry.erda.cloud/erda/terminus-nodejs:12.13

ENV NODE_OPTIONS=--max_old_space_size=1024

RUN yum install -y java-11-openjdk && rm -rf /var/cache/yum
RUN npm i -g @terminus/trnw-cli@2.6.6 && npm cache clean --force;

COPY --from=builder /opt/action/run /opt/action/run
