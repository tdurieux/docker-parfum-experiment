FROM node:latest

WORKDIR /app

RUN npm i -g @nestjs/cli && npm cache clean --force;

EXPOSE 9229

CMD ["node","--v"]
