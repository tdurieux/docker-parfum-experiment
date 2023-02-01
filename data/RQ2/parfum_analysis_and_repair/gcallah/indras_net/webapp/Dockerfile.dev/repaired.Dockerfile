FROM node:10-alpine

ENV ENV="/etc/profile"

RUN apk update && \
    apk upgrade && \
    apk --update --no-cache add \
    gcc \
    bash \
    tree \
    nano \
    vim \
    rm -rf /var/cache/apk/*

WORKDIR /home

ADD package.json .
ADD .ashrc .

RUN npm install && npm cache clean --force;
RUN npm audit fix
RUN cat .ashrc >> "$ENV"

CMD ["npm", "start"]
