FROM node:16-alpine
ENV TZ Asia/Shanghai
WORKDIR /tellery-api

COPY yarn.lock ./
COPY package.json  ./
RUN yarn install --production && yarn cache clean;
COPY dist dist
COPY config config
ENTRYPOINT ["npm", "run"]
CMD ["start"]