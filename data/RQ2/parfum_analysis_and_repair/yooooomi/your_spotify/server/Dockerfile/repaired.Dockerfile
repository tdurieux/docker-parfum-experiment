FROM node:16-alpine

WORKDIR /app

ENV MONGO_ENDPOINT=mongodb://mongo:27017/your_spotify

RUN apk add --no-cache python3 gcc g++ make cmake
RUN npm install -g nodemon && npm cache clean --force;

COPY package.json package.json
COPY yarn.lock yarn.lock
COPY tsconfig.json tsconfig.json
COPY .prettierrc .prettierrc
COPY .eslintrc.js .eslintrc.js
RUN sed -i 's@"extends": "../tsconfig.json",@@g' tsconfig.json

RUN yarn --frozen-lockfile

COPY src/ src/
COPY scripts/ scripts/

ENTRYPOINT [ "sh", "scripts/run/run.sh" ]