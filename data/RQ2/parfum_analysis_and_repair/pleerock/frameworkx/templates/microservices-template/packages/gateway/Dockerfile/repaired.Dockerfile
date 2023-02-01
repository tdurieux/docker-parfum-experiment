FROM node:14

WORKDIR /dependencies/category
COPY ./category/package*.json ./
COPY ./category/_ ./
RUN npm install && npm cache clean --force;
RUN npm link

WORKDIR /dependencies/post
COPY ./post/package*.json ./
COPY ./post/_ ./
RUN npm install && npm cache clean --force;
RUN npm link

WORKDIR /dependencies/user
COPY ./user/package*.json ./
COPY ./user/_ ./
RUN npm install && npm cache clean --force;
RUN npm link

WORKDIR /www
COPY ./gateway/package*.json ./
RUN npm i ../dependencies/category && npm cache clean --force;
RUN npm i ../dependencies/post && npm cache clean --force;
RUN npm i ../dependencies/user && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY ./gateway/_ ./

CMD ["node", "index.js" ]