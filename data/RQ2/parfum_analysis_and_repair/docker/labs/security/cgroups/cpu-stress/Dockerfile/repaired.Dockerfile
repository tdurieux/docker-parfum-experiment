FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y stress && rm -rf /var/lib/apt/lists/*;

CMD stress -c 2
