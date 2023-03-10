FROM node:8.12.0-alpine
LABEL maintainer="igauravsehrawat"
LABEL author="Gaurav"

RUN mkdir /opt/app
WORKDIR /opt/app

COPY package.json package.json
RUN npm install && npm cache clean --force;

EXPOSE 4242 9229

ENTRYPOINT ["npm", "run", "debug"]
