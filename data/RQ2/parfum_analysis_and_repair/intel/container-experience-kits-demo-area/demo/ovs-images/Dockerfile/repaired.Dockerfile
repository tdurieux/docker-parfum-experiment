FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y dpdk; rm -rf /var/lib/apt/lists/*;
WORKDIR /home
COPY get-prefix.sh /home
RUN chmod +x /home/get-prefix.sh
ENTRYPOINT ["bash"]
