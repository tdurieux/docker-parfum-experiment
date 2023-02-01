FROM node:8.6.0

ARG cwd=/app

RUN mkdir -p $cwd
WORKDIR $cwd

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install -g nodemon && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8182
