FROM kdeneon/plasma
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y golang git && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/neon
COPY . .
CMD go test -v -race -cover ./session ./ps ./cmd