FROM mongo:3

ENV sourcesdir /go/src/github.com/microservices-demo/user/
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN apt-get update && apt-get install --no-install-recommends -yq git curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz -o go.tar.gz && \
    tar -C /usr/local -xvf go.tar.gz && rm go.tar.gz
RUN go get -v github.com/Masterminds/glide

COPY . ${sourcesdir}
WORKDIR ${sourcesdir}
RUN glide install
