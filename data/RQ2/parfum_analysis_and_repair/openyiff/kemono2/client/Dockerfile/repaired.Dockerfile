FROM node:16.14

ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json", "/app/"]

RUN npm install -g npm && npm cache clean --force;
RUN npm ci --also=dev

COPY . /app

CMD [ "npm", "run", "build" ]