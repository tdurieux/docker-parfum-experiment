FROM node:lts-slim
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./
CMD ["npm", "start"]