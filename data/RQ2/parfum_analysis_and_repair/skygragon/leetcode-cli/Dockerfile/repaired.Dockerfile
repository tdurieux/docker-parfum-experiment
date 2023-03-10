FROM node:alpine
LABEL maintainer="skygragon@gmail.com"

WORKDIR /tmp/leetcode-cli
COPY . .
COPY bin/entrypoint /
RUN npm install && \
    tar zcf /leetcode-cli.tar.gz . && \
    rm -rf /tmp/leetcode-cli && npm cache clean --force;

WORKDIR /root
VOLUME ["/root"]
ENTRYPOINT ["/entrypoint"]
