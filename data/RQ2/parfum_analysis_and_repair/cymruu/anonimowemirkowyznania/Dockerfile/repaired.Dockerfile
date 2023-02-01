FROM node:16-alpine

WORKDIR /src
COPY . .
RUN npm install && npm cache clean --force;
CMD ["npm", "run", "start:docker"]
