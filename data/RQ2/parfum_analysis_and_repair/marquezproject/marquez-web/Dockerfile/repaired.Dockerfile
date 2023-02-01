FROM node:11
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
COPY docker/entrypoint.sh entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
