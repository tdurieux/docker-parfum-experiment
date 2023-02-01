FROM debian
RUN apt-get update && apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["convert", "-", "-resize", "512x512", "-"]
