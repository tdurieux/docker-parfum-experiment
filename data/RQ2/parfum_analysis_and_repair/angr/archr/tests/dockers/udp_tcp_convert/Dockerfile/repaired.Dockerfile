FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y build-essential make && rm -rf /var/lib/apt/lists/*;
COPY . /udp_tcp_convert
WORKDIR udp_tcp_convert
RUN make
CMD ["./udp_server"]
