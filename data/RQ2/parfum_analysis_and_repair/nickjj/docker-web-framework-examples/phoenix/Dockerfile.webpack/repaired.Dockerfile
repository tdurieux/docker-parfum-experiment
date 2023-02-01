FROM node:10.12-alpine
LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

RUN npm install -g yarn && npm cache clean --force;

WORKDIR /app/assets

COPY assets/package.json assets/*yarn* ./
RUN yarn install && yarn cache clean;

COPY . .

CMD ["yarn", "run", "build"]
