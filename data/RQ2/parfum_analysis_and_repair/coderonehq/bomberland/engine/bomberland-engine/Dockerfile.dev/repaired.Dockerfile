FROM node:16.13.2-alpine
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock

COPY bomberland-library/package.json /app/bomberland-library/package.json
COPY bomberland-library/tsconfig.json /app/bomberland-library/tsconfig.json

COPY ./bomberland-engine/package.json /app/bomberland-engine/package.json

WORKDIR /app
RUN yarn install && yarn cache clean;

WORKDIR /app/bomberland-library
ENV ENVIRONMENT=dev
ENTRYPOINT yarn build && cd ../bomberland-engine && yarn install && yarn run start