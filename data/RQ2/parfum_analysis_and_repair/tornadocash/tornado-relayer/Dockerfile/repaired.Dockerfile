FROM node:12
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn && yarn cache clean --force && yarn cache clean;
COPY . .

EXPOSE 8000
ENTRYPOINT ["yarn"]
