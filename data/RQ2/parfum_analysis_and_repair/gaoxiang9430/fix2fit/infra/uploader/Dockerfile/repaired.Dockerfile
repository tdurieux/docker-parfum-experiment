from ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["curl", "--retry", "2", "-X", "PUT", "-T"]

