FROM node:8-alpine

RUN npm config set registry https://registry.npmmirror.com/
RUN mkdir /app
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install && npm cache clean --force;
COPY . /app
RUN npm run build

CMD [ "npm", "run", "server" ]
