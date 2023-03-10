FROM node:17.0.1-slim
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json", "./"]

RUN npm install --production && npm cache clean --force;

COPY . .

CMD ["node", "--no-deprecation", "index.js"]
