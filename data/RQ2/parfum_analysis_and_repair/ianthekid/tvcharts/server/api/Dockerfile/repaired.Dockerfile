FROM node:alpine
WORKDIR /api
COPY ./package.json /api
RUN npm install && npm cache clean --force;
COPY ./mongo.js /api
COPY ./.env /api
COPY ./api /api
EXPOSE 3000
CMD node api.js