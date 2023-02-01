FROM ubuntu:xenial-20190515

RUN mkdir -p /daemon
WORKDIR /daemon

RUN apt clean && cat /etc/apt/sources.list
RUN apt update && apt install --no-install-recommends -y golang ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY dist/daemon /daemon/server

ENTRYPOINT ["/daemon/server", "-host", "0.0.0.0"]
CMD ["-port", "80"]

