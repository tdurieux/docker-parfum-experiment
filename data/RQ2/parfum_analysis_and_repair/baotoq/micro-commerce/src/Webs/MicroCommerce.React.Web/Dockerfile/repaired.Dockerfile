FROM mhart/alpine-node

EXPOSE 3000

WORKDIR /app

COPY yarn.lock ./
COPY package*.json ./
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .

CMD ["yarn", "start:dev"]
