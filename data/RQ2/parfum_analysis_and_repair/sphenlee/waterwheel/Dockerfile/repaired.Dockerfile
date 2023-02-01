FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y dumb-init && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/waterwheel"]

WORKDIR /root

COPY target/release/waterwheel /usr/bin/

CMD ["--help"]
