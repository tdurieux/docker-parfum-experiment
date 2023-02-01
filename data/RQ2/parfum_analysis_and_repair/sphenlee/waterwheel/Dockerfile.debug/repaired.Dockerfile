# alternate Dockerfile which uses the debug build
# (and includes the UI resources as these are not bundled in debug builds)

FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y dumb-init && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/waterwheel"]

WORKDIR /root

COPY ui/dist/ /root/ui/dist/
COPY target/debug/waterwheel /usr/bin/

CMD ["--help"]
