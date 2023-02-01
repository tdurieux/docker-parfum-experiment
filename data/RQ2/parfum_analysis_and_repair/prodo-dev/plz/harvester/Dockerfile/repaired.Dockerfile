FROM ubuntu
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY entrypoint /entrypoint
ENTRYPOINT /entrypoint
