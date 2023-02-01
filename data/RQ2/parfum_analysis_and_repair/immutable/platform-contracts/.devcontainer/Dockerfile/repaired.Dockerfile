FROM node:12.16.0

RUN npm install -g lerna && npm cache clean --force;
RUN npm install -g typescript@2.6.2 && npm cache clean --force;

WORKDIR /app
CMD [ "scripts/entrypoint.sh" ]
