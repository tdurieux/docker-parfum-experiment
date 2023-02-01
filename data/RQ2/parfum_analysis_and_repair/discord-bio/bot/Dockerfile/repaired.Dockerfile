FROM alpine:latest

RUN apk update && \
    apk add --no-cache nodejs npm git nano && \
    git clone https://github.com/discord-bio/bot /home/bot && \
    cd /home/bot && \
    npm i && \
    npm i -g typescript && \
    cp config.example.json config.json && npm cache clean --force;

CMD sh
