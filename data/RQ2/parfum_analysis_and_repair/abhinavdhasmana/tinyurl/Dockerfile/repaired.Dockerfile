FROM node:10

LABEL maintainer="abhinav.dhasmana@live.com"

COPY . /src

WORKDIR /src

RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD [ "npm", "run", "kstart" ]