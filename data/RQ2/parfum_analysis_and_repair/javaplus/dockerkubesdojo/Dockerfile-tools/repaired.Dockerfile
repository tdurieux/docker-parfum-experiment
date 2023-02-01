FROM ubuntu:latest

RUN apt update && \
    apt install --no-install-recommends -y curl tmux vim zsh git jq && \
    curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/*;
