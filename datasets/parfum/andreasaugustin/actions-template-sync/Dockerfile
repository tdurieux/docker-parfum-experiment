#######################################
# image for dev build environment
######################################
FROM alpine:3.16.0 as dev

ARG GH_CLI_VER=2.8.0

# install packages
RUN apk add --update --no-cache bash make git zsh curl tmux musl openssh

RUN wget https://github.com/cli/cli/releases/download/v${GH_CLI_VER}/gh_${GH_CLI_VER}_linux_386.tar.gz -O ghcli.tar.gz
RUN tar --strip-components=1 -xf ghcli.tar.gz

# Make zsh your default shell for tmux
RUN echo "set-option -g default-shell /bin/zsh" >> /root/.tmux.conf

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN mkdir -p /root/.ssh \
  && ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /app

#######################################
# image for creating the documentation
######################################
FROM node:18.4.0-alpine as docs

# install packages
RUN apk add --update --no-cache bash make git zsh curl tmux

# Make zsh your default shell for tmux
RUN echo "set-option -g default-shell /bin/zsh" >> /root/.tmux.conf

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install quality gate
RUN npm install -g markdownlint-cli

WORKDIR /app
