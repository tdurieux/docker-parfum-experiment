FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        nodejs \
        npm && rm -rf /var/lib/apt/lists/*;

COPY . /root
WORKDIR /root
RUN npm install && npm cache clean --force;
ENTRYPOINT node /root/restore-and-verify-backup.js

