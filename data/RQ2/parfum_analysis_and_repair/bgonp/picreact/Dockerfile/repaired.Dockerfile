FROM node:14.15.5-alpine

WORKDIR /picreact

COPY package.json ./
COPY package-lock.json ./

RUN npm i -g -E serve@11.3 && npm cache clean --force;
RUN npm i -s && npm cache clean --force;

COPY . ./
RUN npm run build -s

CMD ["serve", "./build", "-l", "5000", "-n"]
