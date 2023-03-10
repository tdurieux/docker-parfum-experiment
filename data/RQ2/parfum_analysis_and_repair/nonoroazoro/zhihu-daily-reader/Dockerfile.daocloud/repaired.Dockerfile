FROM node:latest

WORKDIR /zhihu-daily-reader

COPY . /zhihu-daily-reader

RUN npm install --production && npm cache clean --force;

VOLUME /zhihu-daily-reader

EXPOSE 8888

CMD ["npm", "start"]
