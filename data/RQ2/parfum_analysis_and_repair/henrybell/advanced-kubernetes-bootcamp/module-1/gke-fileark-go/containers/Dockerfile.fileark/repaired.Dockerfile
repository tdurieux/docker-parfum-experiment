FROM debian:9.1

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY gopath/bin/fileark scripts/fileark.sh /

RUN chmod a+x /fileark.sh

ENTRYPOINT ["/fileark.sh"]
