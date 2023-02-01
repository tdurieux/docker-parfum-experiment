FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
ADD hello.c /build/hello.c
RUN gcc /build/hello.c -o /build/hello
ENTRYPOINT ["/build/hello"]
