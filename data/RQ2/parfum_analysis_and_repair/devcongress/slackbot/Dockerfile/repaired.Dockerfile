FROM library/node:slim

COPY . /app

RUN cd /app \
    && npm install --production && npm cache clean --force;

WORKDIR /app
EXPOSE 3000
CMD [ "npm", "start" ]
