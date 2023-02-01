FROM node:latest

RUN mkdir /fs
WORKDIR /fs
COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 7000
ENTRYPOINT [ "/fs/run.sh" ]