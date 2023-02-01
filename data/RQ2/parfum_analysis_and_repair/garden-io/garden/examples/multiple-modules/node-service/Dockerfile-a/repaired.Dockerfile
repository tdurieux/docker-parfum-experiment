FROM node:9-alpine

ENV PORT=8080
ENV ENVIRONMENT=a
ENV HELLO_PATH=/hello-a
EXPOSE ${PORT}
WORKDIR /app

ADD package.json /app
RUN npm install && npm cache clean --force;

ADD . /app

CMD ["npm", "start"]
