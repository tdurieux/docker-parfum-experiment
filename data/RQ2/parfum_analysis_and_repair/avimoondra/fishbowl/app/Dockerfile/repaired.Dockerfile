FROM node:lts-alpine
EXPOSE 3000
WORKDIR /usr/app
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .
ENTRYPOINT ["yarn"]
CMD ["run", "start"]
