FROM node:12-slim

RUN apt-get update && apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

ENV NODE_ENV=production

WORKDIR /app
COPY ./package.json .
RUN npm install --production --no-color --no-progress && npm cache clean --force;
COPY . .
RUN npm run build

ENTRYPOINT ["npm", "start"]
