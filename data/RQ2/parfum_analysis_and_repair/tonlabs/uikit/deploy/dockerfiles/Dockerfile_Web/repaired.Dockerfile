FROM node:12.14.1

USER node
RUN mkdir -p /home/node/.ssh/ && ssh-keyscan github.com >> /home/node/.ssh/known_hosts
USER root
RUN apt-get update; \
    apt-get -y --no-install-recommends install sudo; rm -rf /var/lib/apt/lists/*; \
    apt-get install --no-install-recommends -y gawk;