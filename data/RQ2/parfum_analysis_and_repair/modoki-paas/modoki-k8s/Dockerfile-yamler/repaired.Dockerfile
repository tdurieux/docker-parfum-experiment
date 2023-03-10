FROM golang:1.15.0 as tools
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV GO111MODULE=on
RUN go get sigs.k8s.io/kustomize/kustomize/v3@v3.3.0

FROM golang:1.15.0 as builder

COPY . /work
WORKDIR /work
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go build -o /modoki-yamler ./yamler

FROM debian:10

COPY --from=tools /usr/local/bin/dockerize /bin
COPY --from=tools /go/bin/kustomize /bin
COPY ./scripts/ /bin/
COPY --from=builder /modoki-yamler /bin
COPY ./schema /schema
COPY yamler/templates /templates

ENTRYPOINT [ "/bin/yamler-entrypoint.sh" ]