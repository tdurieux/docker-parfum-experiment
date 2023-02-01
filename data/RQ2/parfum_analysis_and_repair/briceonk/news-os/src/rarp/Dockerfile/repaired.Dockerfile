from ubuntu:focal
RUN apt-get update && apt-get install -y --no-install-recommends rarpd && rm -rf /var/lib/apt/lists/*;
COPY ethers /etc/ethers

ENTRYPOINT ["/usr/sbin/rarpd", "-aedv"]
