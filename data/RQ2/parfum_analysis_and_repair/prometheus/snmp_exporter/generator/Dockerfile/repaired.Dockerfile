FROM golang:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest && rm -rf /var/lib/apt/lists/*;

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
