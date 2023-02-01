FROM node:alpine
WORKDIR "/app"
COPY ./package.json ./package-lock.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
CMD ["npm", "run", "start:dev"]