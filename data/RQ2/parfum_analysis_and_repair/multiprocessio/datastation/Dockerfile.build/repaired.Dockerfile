FROM node:17-bullseye

WORKDIR /datastation

# Install Golang
RUN curl -f -L https://go.dev/dl/go1.18.linux-amd64.tar.gz -o /tmp/go.tar.gz && tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz
RUN ln -s /usr/local/go/bin/go /usr/bin/go
