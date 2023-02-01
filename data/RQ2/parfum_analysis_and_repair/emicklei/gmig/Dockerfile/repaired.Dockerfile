FROM golang

RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

WORKDIR /go/src/github.com/emicklei/gmig
COPY . .
ARG version
RUN go test -v -cover
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.version=$version" .


FROM alpine
COPY --from=0 /go/src/github.com/emicklei/gmig /usr/bin/
COPY --from=0 /etc/ssl/certs/ /etc/ssl/certs/

ENTRYPOINT ["gmig"]