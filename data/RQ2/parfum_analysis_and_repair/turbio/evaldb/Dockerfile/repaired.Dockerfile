FROM golang:1.14.4

RUN apt-get update
RUN apt-get install --no-install-recommends -y libjansson-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /go/src/github.com/turbio/evaldb

WORKDIR /go/src/github.com/turbio/evaldb

COPY . .

RUN make

RUN mkdir /db

EXPOSE 5000

ENTRYPOINT ["./gateway", "-path", "/db"]
