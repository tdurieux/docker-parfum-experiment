FROM debian:latest

RUN apt-get update && apt-get -y --no-install-recommends install nmap && rm -rf /var/lib/apt/lists/*;
