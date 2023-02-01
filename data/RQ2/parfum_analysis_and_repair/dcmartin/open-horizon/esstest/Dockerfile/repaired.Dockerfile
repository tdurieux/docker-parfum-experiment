FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -qq -y bash socat curl jq && rm -rf /var/lib/apt/lists/*;
COPY rootfs /
CMD ["/usr/bin/run.sh"]
EXPOSE 8080
