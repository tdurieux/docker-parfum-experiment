FROM alpine:3.14

RUN apk update && \
    apk add --no-cache bash sshpass openssh jq sudo curl && \
    curl -f -LO "https://dl.k8s.io/release/v1.22.4/bin/linux/amd64/kubectl" && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    apk del sudo curl
