FROM node:10-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY ./package.json ./yarn.lock ./
RUN yarn && yarn cache clean;

COPY . .
ENV PORT=3300
EXPOSE 3300
CMD ["npm", "run", "start"]
