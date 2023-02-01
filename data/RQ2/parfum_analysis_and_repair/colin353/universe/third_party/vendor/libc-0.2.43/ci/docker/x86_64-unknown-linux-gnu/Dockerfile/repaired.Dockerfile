FROM ubuntu:18.04
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc libc6-dev ca-certificates && rm -rf /var/lib/apt/lists/*;
ENV PATH=$PATH:/rust/bin
