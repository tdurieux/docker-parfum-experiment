FROM golang:1.11

RUN apt-get update && apt-get -y --no-install-recommends install mysql-client && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 > /usr/bin/dep && chmod +x /usr/bin/dep
