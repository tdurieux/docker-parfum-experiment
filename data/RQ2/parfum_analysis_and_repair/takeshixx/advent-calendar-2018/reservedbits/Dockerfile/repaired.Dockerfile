FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y nmap && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
COPY wrapper.sh .
CMD ["/usr/bin/ncat", "-k", "-l", "--exec", "/usr/src/app/wrapper.sh", "--send-only", "1337"]
