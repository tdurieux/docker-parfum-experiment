FROM node:16.14.2-alpine
WORKDIR /app
COPY ./ ./
RUN npm install && npm cache clean --force;
CMD [ "npm", "start" ]
