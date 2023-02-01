FROM node:8.16.2-alpine
WORKDIR /opt/app
COPY . .
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
EXPOSE 9999