FROM node:latest

COPY . /image

WORKDIR /image

RUN npm i && npm cache clean --force;

EXPOSE 2022

CMD [""]