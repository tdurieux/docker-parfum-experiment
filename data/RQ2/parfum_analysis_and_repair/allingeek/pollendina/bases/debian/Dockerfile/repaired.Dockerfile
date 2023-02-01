FROM debian:jessie
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
