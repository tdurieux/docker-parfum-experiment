FROM debian:stable-slim

RUN apt-get update && apt-get install --no-install-recommends -y xinetd && apt-get clean && rm -rf /var/apt/lists/*
RUN useradd -u 8888 -m ruisseau

CMD ["xinetd", "-dontfork"]
