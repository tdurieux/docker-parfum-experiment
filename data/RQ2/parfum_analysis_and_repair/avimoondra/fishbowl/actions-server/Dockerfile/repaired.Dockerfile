FROM node:lts-alpine
EXPOSE 3001
WORKDIR /usr/app
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .
RUN yarn run build
ENTRYPOINT ["yarn"]
CMD ["run", "start"]
