FROM node:14-alpine
WORKDIR /usr/src/app
COPY . .
RUN npm install -s && npm cache clean --force;
EXPOSE ${APPLICATION_PORT}
CMD ["npm", "start"]
