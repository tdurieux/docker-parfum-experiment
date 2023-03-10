FROM node:10
WORKDIR /usr/app/mailbag
COPY client ./client
COPY server ./server
WORKDIR /usr/app/mailbag/client
RUN npm install && npm cache clean --force;
RUN npx webpack --mode production
WORKDIR /usr/app/mailbag/server
RUN npm install && npm cache clean --force;
RUN npx tsc
EXPOSE 80
CMD [ "node", "./dist/server.js" ]