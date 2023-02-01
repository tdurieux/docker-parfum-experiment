FROM erlio/docker-vernemq:latest

RUN apt update && apt install --no-install-recommends dnsutils -y && rm -rf /var/lib/apt/lists/*;

COPY run.sh /run.sh

CMD ["/run.sh"]
