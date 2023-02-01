FROM haproxy:1.8
RUN apt-get update && apt-get install --no-install-recommends -y curl dnsutils iputils-ping socat && rm -rf /var/lib/apt/lists/*;
