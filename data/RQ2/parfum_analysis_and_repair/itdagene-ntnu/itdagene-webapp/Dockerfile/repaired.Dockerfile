FROM node:12 as builder

RUN mkdir /app
WORKDIR /app

COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;

ARG RELEASE
ARG SENTRY_AUTH_TOKEN
ARG SENTRY_ORG
ARG SENTRY_PROJECT
ARG COMMIT_SHA

ENV NODE_ENV production
ENV SENTRY_AUTH_TOKEN ${SENTRY_AUTH_TOKEN}
ENV RELEASE ${RELEASE}
ENV SENTRY_ORG ${SENTRY_ORG}
ENV SENTRY_PROJECT ${SENTRY_PROJECT}
ENV COMMIT_SHA ${COMMIT_SHA}

COPY . /app

RUN yarn schema:prod && yarn cache clean;
RUN yarn relay && yarn cache clean;
RUN yarn build && yarn cache clean;

FROM node:16-alpine
LABEL org.opencontianers.image.authors="web@itdagene.no"
RUN mkdir /app
WORKDIR /app/

ARG RELEASE
ENV RELEASE ${RELEASE}

COPY --from=builder /app/package.json .
COPY --from=builder /app/yarn.lock .
COPY --from=builder /app/public/static static
RUN yarn --prod && yarn cache clean;
COPY --from=builder /app/.next .next

ENTRYPOINT ["yarn", "start"]
