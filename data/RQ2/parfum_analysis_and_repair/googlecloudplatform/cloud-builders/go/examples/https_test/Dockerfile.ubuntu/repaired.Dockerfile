FROM ubuntu

RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY gopath/bin/https_test /https_test

ENTRYPOINT ["/https_test"]
