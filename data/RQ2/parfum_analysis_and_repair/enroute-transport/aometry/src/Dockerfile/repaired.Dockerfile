FROM node:16.14-alpine

WORKDIR /home/aometry
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
CMD ["npm", "start"]