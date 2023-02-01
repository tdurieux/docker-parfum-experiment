FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y firefox && rm -rf /var/lib/apt/lists/*;
CMD ["/usr/bin/firefox"]
