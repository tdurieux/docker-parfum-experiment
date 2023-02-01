FROM busybox:1.0
RUN apt-get install -y --no-install-recommends python && apt-get clean && rm /var/lib/apt/lists/*

CMD ["go", "run", "main.go"]