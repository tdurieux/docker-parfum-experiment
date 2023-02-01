FROM node:latest

RUN npm -g config set user root
RUN npm install -g http-server && npm cache clean --force;
WORKDIR /stbui
COPY . /stbui
RUN npm install && npm run build && npm cache clean --force;
RUN cd ./dist

EXPOSE 8080

CMD http-server -d