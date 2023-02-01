# Development Build
FROM node:alpine AS development

WORKDIR /app

COPY package*.json ./

RUN yarn install && yarn cache clean;

RUN yarn global add nodemon

COPY . .

RUN yarn build


# Production Build
FROM node:alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY package*.json ./

RUN yarn install --prod && yarn cache clean;

COPY . .

COPY --from=development /app/dist ./dist

# Install pm2 daemon
RUN yarn global add pm2

CMD ["pm2-runtime", "dist/index.js", "--output", "/tmp/logs/out.log", "--error", "/tmp/logs/error.log", "--machine-name", "bot"]