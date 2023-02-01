FROM node:8

COPY . /

RUN npm i && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT ["node"]
