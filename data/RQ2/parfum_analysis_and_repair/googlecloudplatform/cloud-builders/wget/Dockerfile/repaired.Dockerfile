FROM gcr.io/gcp-runtimes/ubuntu_20_0_4

RUN apt-get update && \
  apt-get -y --no-install-recommends install wget ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY notice.sh /usr/bin
ENTRYPOINT ["/usr/bin/notice.sh"]
