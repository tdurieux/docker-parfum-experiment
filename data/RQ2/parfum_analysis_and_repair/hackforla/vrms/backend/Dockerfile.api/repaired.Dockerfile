FROM node:14.11.0 AS api-development
RUN mkdir /srv/backend
WORKDIR /srv/backend
RUN mkdir -p node_modules
COPY package.json yarn.lock ./
RUN yarn install --pure-lockfile && yarn cache clean;
COPY . .

FROM node:14.11.0 AS api-test
RUN mkdir /srv/backend
WORKDIR /srv/backend
COPY package.json yarn.lock ./
RUN yarn install --silent && yarn cache clean;
RUN mkdir -p node_modules

FROM node:14.11.0-slim AS api-production
EXPOSE 4000
USER node
WORKDIR /srv/backend
COPY --from=api-development /srv/backend/node_modules ./node_modules
COPY . .
CMD ["npm", "run", "dev"]

