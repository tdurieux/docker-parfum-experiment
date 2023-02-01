FROM golang:1.15-buster AS Builder

RUN mkdir -p /src
COPY . /src/gopherCap
WORKDIR /src/gopherCap

RUN apt-get update && apt-get install --no-install-recommends -y libpcap-dev && rm -rf /var/lib/apt/lists/*;
RUN go get -u
RUN go build -o /tmp/gopherCap .

FROM debian:buster
RUN apt-get update && apt-get install --no-install-recommends -y libpcap0.8 && apt-get -y autoremove && apt-get -y autoclean && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=Builder /tmp/gopherCap /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/gopherCap" ]
