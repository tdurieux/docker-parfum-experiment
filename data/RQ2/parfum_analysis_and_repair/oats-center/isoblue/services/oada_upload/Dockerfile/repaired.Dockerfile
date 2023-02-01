FROM node

RUN mkdir /code
WORKDIR /code

COPY package*.json yarn.lock tsconfig.json ./
RUN ls && yarn install && yarn cache clean;
COPY "./" "/code/"

CMD ["yarn", "run", "start"]