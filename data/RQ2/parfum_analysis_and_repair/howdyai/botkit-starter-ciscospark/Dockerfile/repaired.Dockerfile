FROM library/node:argon-slim

COPY . /app

RUN cd /app \
  && npm install --production && npm cache clean --force;

WORKDIR /app

CMD ["node", "bot.js"]
