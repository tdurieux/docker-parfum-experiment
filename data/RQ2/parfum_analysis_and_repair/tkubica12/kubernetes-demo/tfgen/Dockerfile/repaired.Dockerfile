FROM debian:9-slim

RUN apt update && apt install --no-install-recommends curl jq -y && rm -rf /var/lib/apt/lists/*;

USER tomas
RUN mkdir -p /home/tomas
COPY gen.sh /home/tomas
RUN chmod +x /home/tomas/gen.sh

CMD ["/home/tomas/gen.sh"] ls
