# Build frontend
FROM node:12-slim as builder

WORKDIR /app
COPY package.json ./
RUN yarn install --silent && yarn cache clean;
COPY . ./
EXPOSE 3030
CMD ["yarn", "start"]