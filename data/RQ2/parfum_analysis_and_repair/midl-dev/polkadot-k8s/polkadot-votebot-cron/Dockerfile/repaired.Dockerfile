FROM node:16-alpine

WORKDIR /app

COPY . /app

RUN ls
RUN npm install && npm cache clean --force;
RUN npm run build
RUN npm cache clean --force --loglevel=error

CMD [ "node", "--unhandled-rejections=strict", "index.js" ]
