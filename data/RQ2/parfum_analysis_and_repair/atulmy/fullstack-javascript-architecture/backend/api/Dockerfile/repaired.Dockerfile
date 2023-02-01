FROM node:10
RUN mkdir -p /user/src/app
WORKDIR /user/src/app
COPY ./package*.json ./
RUN npm install --quiet && npm cache clean --force;
COPY . ./
RUN npm run build:prod
EXPOSE 8000
ENTRYPOINT ["node", "build/index.js"]
