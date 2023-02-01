FROM node:12.13-alpine
LABEL maintainer="https://github.com/zgq354/weibo-rss"
RUN mkdir /app
WORKDIR /app

# container init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && \
    echo "e874b55f3279ca41415d290c512a7ba9d08f98041b28ae7c2acb19a545f1c4df  /usr/local/bin/dumb-init" | sha256sum -c - && \
    chmod 755 /usr/local/bin/dumb-init

COPY package.json /app
RUN npm install
COPY . /app

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["npm", "start"]
