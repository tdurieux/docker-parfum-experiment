FROM node:9-alpine

RUN mkdir -p /app/frontend

WORKDIR /app/frontend

COPY  . /app/frontend

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["npm","run","webpack"]