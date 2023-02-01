FROM ubuntu:20.04
RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y certbot python3-certbot-dns-google curl jq && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO "https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl
COPY certbot.sh certbot.sh
RUN chmod +x certbot.sh
CMD ./certbot.sh
