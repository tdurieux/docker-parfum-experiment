FROM fusuf/whatsasena:latest

RUN git clone $GITHUB_REPO_URL /root/WhatsAsena
WORKDIR /root/WhatsAsena/
ENV TZ=Europe/Istanbul
RUN npm install supervisor -g && npm cache clean --force;
RUN apk --no-cache --virtual build-dependencies add \
    python \
    make \
    g++ \
    && npm install \
    && apk del build-dependencies && npm cache clean --force;
RUN npm install && npm cache clean --force;

CMD ["node", "bot.js"]
