FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends dnsutils curl -y && rm -rf /var/lib/apt/lists/*;

CMD tail -f /dev/null