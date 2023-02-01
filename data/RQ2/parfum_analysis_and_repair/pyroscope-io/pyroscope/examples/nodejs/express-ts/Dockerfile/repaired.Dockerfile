FROM node:latest

WORKDIR /app

COPY package.json .
COPY tsconfig.json .
RUN yarn && yarn cache clean;
COPY *.ts .
RUN yarn build && yarn cache clean;
ENV DEBUG=pyroscope
CMD ["yarn", "run", "run"]

