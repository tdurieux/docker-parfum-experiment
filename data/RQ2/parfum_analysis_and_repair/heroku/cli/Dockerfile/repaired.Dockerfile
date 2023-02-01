FROM node:latest

MAINTAINER Jeff Dickey

RUN curl -f https://cli-assets.heroku.com/install-ubuntu.sh | sh && rm -rf /var/lib/apt/lists/*

CMD heroku
