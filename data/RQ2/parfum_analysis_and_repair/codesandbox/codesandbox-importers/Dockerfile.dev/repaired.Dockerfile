FROM node:14.13.1
MAINTAINER Ives van Hoorne

ADD .git /workspace/.git

RUN apt-get update && apt-get install --no-install-recommends -y zsh vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace
RUN git reset --hard
