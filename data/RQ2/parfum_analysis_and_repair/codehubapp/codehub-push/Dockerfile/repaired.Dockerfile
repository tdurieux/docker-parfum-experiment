FROM node:11
LABEL maintainer="thedillonb@gmail.com"

WORKDIR /app
COPY . /app

RUN npm install && npm cache clean --force;

CMD ["node", "/app/bin/main"]
