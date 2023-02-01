# Build the final container. And install
FROM montferret/chromium:99.0.4844.0

RUN apt-get update && apt-get install --no-install-recommends -y dumb-init && rm -rf /var/lib/apt/lists/*;

# Add the binary
COPY lab .

VOLUME test

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]
CMD ["/bin/sh", "-c", "./entrypoint.sh & ./lab --wait http://127.0.0.1:9222/json/version --files=file:///test"]