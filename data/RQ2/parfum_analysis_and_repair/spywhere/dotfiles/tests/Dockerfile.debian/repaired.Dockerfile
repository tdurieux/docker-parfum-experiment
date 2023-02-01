FROM debian:bullseye-slim

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL get.docker.com -o install-docker.sh
RUN sh install-docker.sh
