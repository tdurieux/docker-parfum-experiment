FROM node:latest

COPY . /build

WORKDIR /build

RUN npm i && npm cache clean --force;

EXPOSE 2022

CMD ["npm", "run", "testbed"]