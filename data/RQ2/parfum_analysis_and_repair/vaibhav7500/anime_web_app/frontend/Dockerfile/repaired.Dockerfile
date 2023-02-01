FROM node:16
WORKDIR /app
COPY . .
WORKDIR /app/backend
RUN npm install && npm cache clean --force;
WORKDIR /app/frontent
RUN npm install && npm cache clean --force;

WORKDIR /app
RUN sh ./build.sh
WORKDIR /app/backend
EXPOSE 8080
CMD ["node", "app.js"]