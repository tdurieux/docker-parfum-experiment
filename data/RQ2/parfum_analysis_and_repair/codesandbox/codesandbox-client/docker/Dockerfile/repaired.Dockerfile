FROM node:10.22.1-buster
LABEL maintainer "Ives van Hoorne"

RUN mkdir /workspace
ADD .git /workspace/.git

WORKDIR /workspace
RUN git reset --hard
RUN apt update && apt install --no-install-recommends -y nano less tmux zsh vim && rm -rf /var/lib/apt/lists/*;
