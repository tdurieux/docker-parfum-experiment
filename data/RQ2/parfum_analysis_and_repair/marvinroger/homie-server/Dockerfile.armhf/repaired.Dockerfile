FROM armhf/node:5.3

RUN npm install -g homie-server && npm cache clean --force;

RUN mkdir /data

EXPOSE 80 35590

VOLUME /data

CMD ["homie", "--dataDir", "/data"]
