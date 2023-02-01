FROM montferret/chromium:99.0.4844.0

RUN apt-get update && apt-get install --no-install-recommends -y dumb-init ca-certificates && rm -rf /var/lib/apt/lists/*;

# Add worker binary
COPY worker .
EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]
CMD ["/bin/sh", "-c", "/entrypoint.sh & /worker"]
