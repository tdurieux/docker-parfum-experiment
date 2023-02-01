FROM mhart/alpine-node:8
WORKDIR /var/socializer
ENV NODE_ENV production
COPY package.json yarn.lock ./
RUN yarn install --production && yarn cache clean;
COPY . .
RUN yarn build
EXPOSE 3000
CMD ["yarn", "serve"]
