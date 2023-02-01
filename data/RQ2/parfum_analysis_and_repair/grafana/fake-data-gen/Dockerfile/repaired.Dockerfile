FROM node:17.9-alpine

COPY ./src /usr/src/fake-data-gen
WORKDIR /usr/src/fake-data-gen
RUN npm install && npm cache clean --force;

CMD [ "sh", "-c", "/usr/src/fake-data-gen/start.sh" ]
