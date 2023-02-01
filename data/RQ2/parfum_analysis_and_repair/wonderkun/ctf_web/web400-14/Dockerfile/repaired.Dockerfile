FROM node:8.15-jessie

RUN mkdir /var/opt/node && \ 
    apt-get update && \
    apt-get install --no-install-recommends -y cowsay && \
    ln -s /usr/games/cowsay /usr/local/bin/cowsay && rm -rf /var/lib/apt/lists/*;

COPY  ./src /var/opt/node/
COPY ./package.json /var/opt/node/

WORKDIR /var/opt/node/
RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["node","server.js"]