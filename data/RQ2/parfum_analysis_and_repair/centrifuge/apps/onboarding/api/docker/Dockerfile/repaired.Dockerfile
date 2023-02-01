FROM node:12.16.3

ENV NODE_ENV=production

WORKDIR /app

COPY *.yml *.json yarn.lock ./
COPY .yarn/plugins ./.yarn/plugins/
COPY .yarn/releases ./.yarn/releases/
COPY onboarding/api ./onboarding/api/

RUN yarn set version berry
RUN yarn install && yarn cache clean;
RUN yarn workspace @centrifuge/onboarding-api testOnce && yarn cache clean;

RUN yarn workspace @centrifuge/onboarding-api build && yarn cache clean;

EXPOSE 3100

CMD ["yarn", "workspace", "@centrifuge/onboarding-api", "start:prod"]