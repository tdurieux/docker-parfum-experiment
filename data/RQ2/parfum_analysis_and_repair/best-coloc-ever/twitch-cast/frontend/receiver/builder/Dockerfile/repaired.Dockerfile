FROM node

RUN npm install --global \
    riot \
    webpack \
    browser-sync && npm cache clean --force;

ADD ./watch.sh /watch.sh

WORKDIR /app

CMD ["/watch.sh"]
