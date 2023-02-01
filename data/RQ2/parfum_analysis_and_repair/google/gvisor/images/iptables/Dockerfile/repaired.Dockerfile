FROM ubuntu
RUN apt update && apt install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
