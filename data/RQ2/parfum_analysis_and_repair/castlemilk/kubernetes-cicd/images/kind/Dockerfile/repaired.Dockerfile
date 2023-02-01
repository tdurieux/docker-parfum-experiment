FROM alpine:3.10.3
RUN apk update && apk add --no-cache curl docker bash make ncurses
RUN curl -f -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl
RUN curl -f -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.6.1/kind-linux-amd64 && \
    chmod +x /usr/local/bin/kind

ENTRYPOINT ["kind"]