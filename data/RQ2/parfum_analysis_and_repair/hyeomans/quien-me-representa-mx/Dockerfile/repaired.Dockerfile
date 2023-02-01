FROM node:14

WORKDIR /app

COPY *.json /app/
COPY *.lock /app/

RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . /app/
RUN npx next telemetry disable

RUN yarn build && yarn cache clean;

EXPOSE 3000


CMD ["yarn", "start"]
