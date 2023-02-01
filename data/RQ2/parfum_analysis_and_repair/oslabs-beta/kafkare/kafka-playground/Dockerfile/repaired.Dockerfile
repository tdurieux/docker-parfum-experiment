FROM node:latest

COPY . /image

WORKDIR /image

RUN npm i && npm cache clean --force;

EXPOSE 5000

CMD ["npm", "run", "testbed"]