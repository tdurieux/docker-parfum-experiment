FROM docker.io/mhart/alpine-node:16.4.2@sha256:c9014e9e5b33f29d47c867ea548edc0235ba71677f40456409a44c278d8a8e01
WORKDIR /app

COPY package.json yarn.lock ./
# hadolint ignore=DL3060
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .
# hadolint ignore=DL3060
RUN yarn workspace @parca/web install

EXPOSE 3000

CMD ["yarn", "workspace", "@parca/web", "dev"]
