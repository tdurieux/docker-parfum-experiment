FROM --platform=$TARGETPLATFORM node:14-alpine
WORKDIR /usr/src/app
ADD package*.json .
RUN npm install && npm cache clean --force;
ADD . .
EXPOSE 3000
CMD [ "node", "index.js" ]