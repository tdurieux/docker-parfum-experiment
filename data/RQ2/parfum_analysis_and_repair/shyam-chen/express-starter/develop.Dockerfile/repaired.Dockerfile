FROM node:14

WORKDIR /usr/src
VOLUME [ "/usr/src" ]

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD [ "yarn", "serve" ]
