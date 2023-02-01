FROM node:10
RUN npm i -g typescript && npm cache clean --force;
COPY ./app/* /app/
WORKDIR /app
ARG CACHEBUST=1
RUN npm i && npm cache clean --force;
RUN tsc
