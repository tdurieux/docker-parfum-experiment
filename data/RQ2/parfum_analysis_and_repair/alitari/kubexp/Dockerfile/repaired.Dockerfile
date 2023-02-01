FROM golang:1.8

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/alitari/kubexp/
COPY . .

RUN go get -d -v ./...
ENV GOOS="linux"
RUN ./build.sh bin


ENTRYPOINT ["/go/src/github.com/alitari/kubexp/bin/kubexp"]

