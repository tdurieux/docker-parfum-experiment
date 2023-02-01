FROM debian:latest
RUN apt-get update && \
    apt-get install --no-install-recommends -y bash zsh ksh && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . /app
