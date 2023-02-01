FROM node:10-alpine
WORKDIR /usr/src/app
COPY ./server/package*.json ./
RUN npm install && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY . .
COPY ./server/. .
WORKDIR /usr/src/app/frontend
COPY ./frontend/package*.json ./
RUN npm install && npm cache clean --force;
COPY ./frontend/. .
RUN npm run build
RUN mv /usr/src/app/frontend/build /usr/src/app/build
WORKDIR /usr/src/app
EXPOSE 4000
CMD ["node", "server.js"]