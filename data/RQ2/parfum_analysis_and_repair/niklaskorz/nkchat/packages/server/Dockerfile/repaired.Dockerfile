FROM node:12

ENV PORT 3000

COPY . /server
WORKDIR /server
RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 3000

CMD ["node", "./build/index.js"]
