FROM node:16

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production && npm cache clean --force;
COPY . .
RUN npm run build && npm install -g serve && npm cache clean --force;

CMD [ "serve", "-s", "build", "-l", "3000" ]
