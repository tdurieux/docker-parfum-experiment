FROM node:7.9.0-alpine
WORKDIR .
ADD ./frontend .
RUN npm install && npm cache clean --force;
EXPOSE 1337
CMD ["npm", "run", "start:prod"]
