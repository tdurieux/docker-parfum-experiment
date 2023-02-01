FROM node:8.9 as sources

RUN apt-get update && apt-get install --no-install-recommends build-essential wget libpng-dev -y curl && rm -rf /var/lib/apt/lists/*;

RUN ldconfig

WORKDIR /app

COPY ./package.json ./yarn.lock ./

RUN yarn

COPY . .

ARG VERSION
ARG TOKEN
ARG SENTRYURL
RUN yarn build

# Upload sourcemaps
RUN bash ./uploadsourcemaps.sh

FROM nginx:1.13-alpine

RUN mkdir /frontend
WORKDIR /frontend

COPY --from=sources /app/build/* ./
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
