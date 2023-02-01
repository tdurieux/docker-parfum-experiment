FROM node

COPY ./http.js /src/http.js
COPY ./package.json /src/package.json

RUN cd /src; npm install --production && npm cache clean --force;

EXPOSE 8003

CMD ["node", "/src/http.js"]
