FROM node:9.11-alpine

WORKDIR /app/

COPY package.json yarn.lock /app/
RUN npm install --production -s --no-progress --pure-lockfile && npm cache clean --force;

COPY . /app/

CMD ["node", "server"]