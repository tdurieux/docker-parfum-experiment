FROM node:9-slim

WORKDIR /usr/src/app
COPY . ./
RUN npm install && npm cache clean --force;
RUN npm run build
RUN rm -rf node_modules
RUN rm -r src
RUN npm install --production && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "run", "start:production"]
