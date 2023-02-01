ARG BASE_IMAGE="codercom/enterprise-base:ubuntu"
FROM ${BASE_IMAGE}

USER root

# Prep
RUN apt clean \
  && apt update -y

# Install Golang
RUN sudo add-apt-repository ppa:longsleep/golang-backports \
  && apt update -y \
  && apt install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;

# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
  && sudo apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Corepack / Yarn
RUN corepack enable \
  && npm install --global corepack && npm cache clean --force;

# Install Angular CLI
RUN yarn global add @angular/cli --prefix /usr/local

# Install Taskfile
RUN env GOBIN=/bin go install github.com/go-task/task/v3/cmd/task@latest

USER coder
