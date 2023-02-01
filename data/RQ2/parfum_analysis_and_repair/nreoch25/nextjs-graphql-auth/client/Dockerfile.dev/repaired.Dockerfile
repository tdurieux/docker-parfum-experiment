FROM node:alpine
WORKDIR /app
COPY ./package.json ./
COPY yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .
CMD ["yarn", "dev"]