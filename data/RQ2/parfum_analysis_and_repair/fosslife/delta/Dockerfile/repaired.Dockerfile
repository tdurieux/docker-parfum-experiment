FROM node:10.13-alpine
ENV NODE_ENV production
ENV REDIS_HOST redis
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && npm cache clean --force;
COPY . .
EXPOSE 3000
CMD node index.js