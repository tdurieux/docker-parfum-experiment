FROM node:12.22

ENV NODE_ENV=development

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "dev"]
