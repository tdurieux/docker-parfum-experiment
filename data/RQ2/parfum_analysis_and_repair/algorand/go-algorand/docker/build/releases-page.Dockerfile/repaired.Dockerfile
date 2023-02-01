FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends git python3 python3-pip -y && \
    pip3 install --no-cache-dir awscli boto3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

CMD ["/bin/bash"]

