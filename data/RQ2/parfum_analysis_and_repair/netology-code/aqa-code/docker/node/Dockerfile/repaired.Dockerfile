FROM node:lts-alpine3.12
WORKDIR /opt/app
COPY . .
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
EXPOSE 9999