FROM node:16
RUN mkdir munetic_express
WORKDIR /munetic_express
COPY . .
RUN npm i esbuild && npm cache clean --force;
RUN npm i && npm cache clean --force;
