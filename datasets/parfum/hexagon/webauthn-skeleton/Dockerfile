FROM node:16-alpine
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN npm install --no-cache
EXPOSE 3000
RUN chmod +x /usr/src/app/docker-entrypoint.sh
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh", "npm", "start"]