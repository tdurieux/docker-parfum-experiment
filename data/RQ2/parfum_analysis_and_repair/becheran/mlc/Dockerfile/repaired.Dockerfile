FROM ubuntu:18.04

RUN apt-get update; apt-get install --no-install-recommends -y ca-certificates; rm -rf /var/lib/apt/lists/*; update-ca-certificates
ADD ./target/release/mlc /bin/mlc
RUN PATH=$PATH:/bin/mlc
