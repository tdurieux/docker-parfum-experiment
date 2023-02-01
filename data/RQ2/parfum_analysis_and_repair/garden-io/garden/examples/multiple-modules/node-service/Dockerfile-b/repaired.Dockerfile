FROM node:9-alpine

ENV PORT=8080
ENV ENVIRONMENT=b
ENV HELLO_PATH=/hello-b
EXPOSE ${PORT}
WORKDIR /app

ADD package.json /app
RUN npm install && npm cache clean --force;

ADD . /app

CMD ["npm", "start"]
