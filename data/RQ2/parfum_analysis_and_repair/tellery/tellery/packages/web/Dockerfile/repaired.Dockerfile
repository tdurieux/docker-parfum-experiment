FROM node:16
ENV TZ Asia/Shanghai
WORKDIR /tellery-web

COPY package.json  ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .
RUN pnpm build
ENTRYPOINT ["npm", "run"]
CMD ["start"]