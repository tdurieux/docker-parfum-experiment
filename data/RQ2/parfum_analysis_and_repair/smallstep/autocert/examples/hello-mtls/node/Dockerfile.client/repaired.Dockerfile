FROM node:lts-alpine

RUN mkdir /src
ADD client.js /src

CMD ["node", "/src/client.js"]