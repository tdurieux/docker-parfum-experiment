FROM node:lts-alpine

RUN mkdir /src
ADD server.js /src

CMD ["node", "/src/server.js"]