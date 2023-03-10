FROM golang:1.15.0 as tools
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV SQLDEF_VERSION v0.5.9
RUN wget https://github.com/k0kubun/sqldef/releases/download/${SQLDEF_VERSION}/mysqldef_linux_amd64.tar.gz \
    && tar -C /usr/local/bin -xzvf mysqldef_linux_amd64.tar.gz \
    && rm mysqldef_linux_amd64.tar.gz

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin

FROM golang:1.15.0 as builder

COPY . /work
WORKDIR /work
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go build -o /modoki-api ./apiserver

FROM alpine:3.12.0

COPY --from=tools /usr/local/bin/mysqldef /bin
COPY --from=tools /usr/local/bin/dockerize /bin
COPY --from=tools /usr/local/bin/kubectl /bin
COPY ./scripts/ /bin/
COPY --from=builder /modoki-api /bin
COPY ./schema /schema

ENTRYPOINT [ "/bin/api-entrypoint.sh" ]
