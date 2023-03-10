FROM node

COPY ./hapi.js /src/hapi.js
COPY ./package.json /src/package.json

RUN cd /src; npm install --production && npm cache clean --force;

EXPOSE 8002

CMD ["node", "/src/hapi.js"]
