FROM golang:1.12
RUN curl -f -sL https://deb.nodesource.com/setup_13.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
VOLUME ["/go", "/app"]
